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

  has_many :source_transactions, as: :source,
                                 class_name: "Transactions::Base",
                                 dependent: :restrict_with_error

  has_many :destination_transactions, as: :destination,
                                      class_name: "Transactions::Base",
                                      dependent: :restrict_with_error

  has_many :initiated_transactions, class_name: "Transactions::Base",
                                    foreign_key: :initiated_by_id,
                                    inverse_of: :initiated_by,
                                    dependent: :restrict_with_error

  has_many :authorized_transactions, class_name: "Transactions::Base",
                                     foreign_key: :authorized_by_id,
                                     inverse_of: :authorized_by,
                                     dependent: :restrict_with_error

  has_many :liability_events, class_name: "Events::Liability",
                              dependent: :restrict_with_error

  has_many :equity_events, class_name: "Events::Equity",
                           dependent: :restrict_with_error

  has_many :crypto_events, -> { crypto }, class_name: "Events::Liability",
                                          dependent: :restrict_with_error

  has_many :fiat_events, -> { fiat }, class_name: "Events::Liability",
                                      dependent: :restrict_with_error

  has_many :coins, -> { distinct }, through: :liability_events
  has_many :contributed_coins, -> { distinct }, through: :equity_events, source: :coin

  has_many :crypto, -> { distinct }, through: :crypto_events, source: :coin
  has_many :fiat, -> { distinct }, through: :fiat_events, source: :coin

  scope :with_crypto, -> { joins(:crypto) }
  scope :with_fiat, -> { joins(:fiat) }

  TWO_FACTOR_DELIVERY_METHODS = {
    sms: "Short message service (SMS)",
    app: "Authenticator application"
  }.with_indifferent_access

  validates :username, uniqueness: { case_sensitive: true },
                       format: { with: /\A[a-zA-Z0-9_\.]*\Z/, multiline: true },
                       presence: true

  validate :username_against_email

  validates :slug, uniqueness: { case_sensitive: true }

  validates :otp_delivery_method, inclusion: { in: TWO_FACTOR_DELIVERY_METHODS.keys }, if: :two_factor_activated?

  validates :phone_number, presence: true,
                           format: { with: /\A\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})\z/ },
                           if: :country_code?

  validates :country_code, presence: true,
                           inclusion: { in: MMT::MobileCountryCodes.with_code_only },
                           if: :phone_number?

  before_validation :adjust_slug, on: :update, if: :username_changed?

  attr_accessor :login

  def display_name
    username
  end

  def coin_history(coin)
    liability_events.where(coin_id: coin.id)
  end

  def liability(coin)
    coin_history(coin).sum(:liability)
  end

  def equity(coin)
    equity_events.where(coin_id: coin.id).sum(:equity)
  end

  def full_phone_number
    "+#{country_code}#{phone_number}"
  end

  def authenticated_by_app?
    otp_delivery_method == "app"
  end

  def authenticated_by_phone?
    otp_delivery_method == "sms"
  end

  def need_two_factor_authentication?(_request)
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
      if (login = conditions.delete(:login))
        where(conditions.to_h).find_by(
          arel_table[:username].lower.eq(login.downcase).or(
            arel_table[:email].lower.eq(login.downcase)
          )
        )
      elsif conditions.key?(:username) || conditions.key?(:email)
        find_by(conditions.to_h)
      end
    end
  end

  private

  def username_against_email
    return true unless Member.where(email: username).exists?
    self.errors.add(:username, "Username taken by email")
  end

  def two_factor_activated?
    two_factor_enabled? && two_factor_enabled_changed?
  end

  def adjust_slug
    self.slug = username
  end
end
