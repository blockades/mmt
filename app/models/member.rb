# frozen_string_literal: true

class Member < ApplicationRecord
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

  has_many :member_coin_events
  has_many :coins, through: :member_coin_events
  has_many :crypto_events, -> { crypto }, class_name: 'MemberCoinEvent'
  has_many :fiat_events, -> { fiat }, class_name: 'MemberCoinEvent'
  has_many :crypto, -> { distinct }, through: :crypto_events, source: :coin
  has_many :fiat, -> { distinct }, through: :fiat_events, source: :coin

  scope :with_crypto, -> { joins(:crypto) }
  scope :with_fiat, -> { joins(:fiat) }

  TWO_FACTOR_DELIVERY_METHODS = { sms: 'Short message service (SMS)', app: 'Authenticator application' }.with_indifferent_access

  validates :username, uniqueness: { case_sensitive: true },
                       format: { with: /\A[a-zA-Z0-9_\.]*\Z/, multiline: true },
                       exclusion: { in: MagicMoneyTree::InaccessibleWords.all },
                       presence: true

  validates :slug, uniqueness: { case_sensitive: true }

  validates :otp_delivery_method, inclusion: { in: TWO_FACTOR_DELIVERY_METHODS.keys }, if: :two_factor_activated?

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

  def publish!(coin_id:, liability:, rate:, transaction_id:)
    transaction_id.member_coin_events.build(
      coin_id: coin_id,
      liability: liability,
      rate: rate,
      member_id: id
    )
  end

  # ===> Balance

  def history(coin_id)
    member_coin_events.where(coin_id: coin_id)
  end

  def liability(coin_id)
    member_coin_events.where(coin_id: coin_id).sum(:liability)
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

  def two_factor_activated?
    two_factor_enabled? && two_factor_enabled_changed?
  end

  def email_against_username
    errors.add(:username, :invalid) if Member.where(email: username).exists?
  end

  def adjust_slug
    self.slug = username
  end
end
