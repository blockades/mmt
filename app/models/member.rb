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

  has_one :live_portfolio, -> { live }, foreign_key: :member_id, class_name: "Portfolio"
  has_many :portfolios
  has_many :holdings, through: :live_portfolio

  scope :no_portfolio, -> { includes(:live_portfolio).where(portfolios: { id: nil }).references(:portfolios) }

  TWO_FACTOR_DELIVERY_METHODS = { sms: 'Short message service (SMS)', app: 'Authenticator application' }.with_indifferent_access

  validates :username, uniqueness: { case_sensitive: true }, format: { with: /^[a-zA-Z0-9_\.]*$/, multiline: true }, presence: true
  validates :slug, uniqueness: { case_sensitive: true }

  validates :otp_delivery_method, inclusion: { in: TWO_FACTOR_DELIVERY_METHODS.values }, if: proc { two_factor_enabled? && two_factor_enabled_changed? }
  validates :phone_number, presence: true, format: { with: /\A\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})\z/ }, if: proc { country_code.present? }
  validates :country_code, presence: true, inclusion: { in: MagicMoneyTree::MobileCountryCodes.with_code_only }, if: proc { phone_number.present? }

  validate :username_against_inaccessible_words
  validate :email_against_username

  before_validation :adjust_slug, on: :update, if: proc { |m| m.username_changed? }

  attr_accessor :login

  # ===> Two Factor Authentication

  def full_phone_number
    "+#{country_code}#{phone_number}"
  end

  def authenticated_by_app?
    otp_delivery_method == 'sms'
  end

  def authenticated_by_phone?
    otp_delivery_method == 'app'
  end

  def setup_two_factor!
    update!(otp_secret_key: self.generate_totp_secret, otp_recovery_codes: self.generate_otp_recovery_codes)
  end

  def confirm_two_factor!(method)
    delivery_method = TWO_FACTOR_DELIVERY_METHODS[method]
    return false unless delivery_method
    update!(two_factor_enabled: true, otp_delivery_method: delivery_method)
  end

  def disable_two_factor!
    update!(otp_secret_key: nil, two_factor_enabled: false, otp_delivery_method: nil)
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

  def email_against_username
    errors.add(:username, :invalid) if Member.where(email: username).exists?
  end

  def username_against_inaccessible_words
    errors.add(:username, :invalid) if MagicMoneyTree::InaccessibleWords.all.include? username.downcase
  end

  def adjust_slug
    self.slug = username
  end
end
