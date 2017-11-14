# frozen_string_literal: true

class Member < ApplicationRecord
  include AggregateRoot

  devise :two_factor_authenticatable,
         :two_factor_recoverable,
         :database_authenticatable,
         :invitable,
         :recoverable,
         :trackable,
         :validatable,
         authentication_keys: [:login]

  has_one_time_password(encrypted: true)
  has_one_time_recovery_codes

  extend FriendlyId
  friendly_id :username, use: :slugged

  has_many :withdrawl_requests
  has_many :outstanding_withdrawl_requests, -> { outstanding }, class_name: 'WithdrawlRequest'
  has_many :notifications, foreign_key: :recipient_id, inverse_of: :recipient

  scope :admin, -> { where admin: true }

  TWO_FACTOR_DELIVERY_METHODS = { sms: 'Short message service (SMS)', app: 'Authenticator application' }.with_indifferent_access

  validates :username, uniqueness: { case_sensitive: true },
                       format: { with: /\A[a-zA-Z0-9_\.]*\Z/, multiline: true },
                       exclusion: { in: MagicMoneyTree::InaccessibleWords.all },
                       presence: true

  validates :slug, uniqueness: { case_sensitive: true }

  validates :otp_delivery_method, inclusion: { in: TWO_FACTOR_DELIVERY_METHODS.keys },
                                  if: proc { two_factor_enabled? && two_factor_enabled_changed? }

  validates :phone_number, presence: true,
                           format: { with: /\A\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})\z/ },
                           if: :country_code?

  validates :country_code, presence: true,
                           inclusion: { in: MagicMoneyTree::MobileCountryCodes.with_code_only },
                           if: :phone_number?

  validate :email_against_username

  before_validation :adjust_slug, on: :update, if: :username_changed?

  attr_accessor :login

  # ===> Publishing Events

  def coin_stream(coin_id)
    "Domain::Member$#{id}:#{coin_id}"
  end

  def publish!(event_class, attributes = {})
    self.load(coin_stream(attributes.fetch(:coin_id)))
    apply event_class.new(data: attributes)
    self.store
  end

  # ===> Balance

  def history(coin_id)
    Rails.application.config.event_store.read_stream_events_backward(coin_stream(coin_id))
  end

  def holdings(coin_id)
    coin_history = history(coin_id)
    coin_history.any? ? coin_history.first.data.fetch(:holdings) : 0
  end

  def available_holdings(coin_id)
    unconcluded_withdrawl_requests = withdrawl_requests.where(coin_id: coin_id)
                                                       .where.not(state: [:completed, :confirmed, :cancelled])
    holdings(coin_id) - unconcluded_withdrawl_requests.sum(:quantity)
  end

  # ===> Two Factor Authentication

  def full_phone_number
    "+#{country_code}#{phone_number}"
  end

  def authenticated_by_app?
    otp_delivery_method == 'app'
  end

  def authenticated_by_phone?
    otp_delivery_method == 'sms'
  end

  def need_two_factor_authentication?(request)
    otp_setup_complete?
  end

  def otp_setup_complete?
    two_factor_enabled? && otp_secret_key.present?
  end

  def otp_setup_incomplete?
    !two_factor_enabled? && otp_secret_key.present?
  end

  def send_authentication_code_by_sms!
    Workers::SmsAuthentication.perform_async(full_phone_number, "Your authentication code is #{direct_otp}")
  end

  class << self
    def find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_h).where(["LOWER(username) = :value OR LOWER(email) = :value", { value: login.downcase }]).first
      elsif conditions.has_key?(:username) || conditions.has_key?(:email)
        where(conditions.to_h).first
      end
    end
  end

  private

  # Handler methods
  def apply_balance(event)
    Rails.logger.info("\n\n#{event.inspect}\n\n")
  end

  def email_against_username
    errors.add(:username, :invalid) if Member.where(email: username).exists?
  end

  def adjust_slug
    self.slug = username
  end
end
