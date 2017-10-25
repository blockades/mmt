# frozen_string_literal: true

class Member < ApplicationRecord
  devise :two_factor_authenticatable,
         :database_authenticatable,
         :invitable,
         :recoverable,
         :trackable,
         :validatable,
         authentication_keys: [:login],
         otp_secret_encryption_key: ENV['OTP_SECRET_ENCRYPTION_KEY']

  has_one_time_password(encrypted: true)

  extend FriendlyId
  friendly_id :username, use: :slugged

  has_one :live_portfolio, -> { live }, foreign_key: :member_id, class_name: "Portfolio"
  has_many :portfolios
  has_many :holdings, through: :live_portfolio

  scope :no_portfolio, -> { includes(:live_portfolio).where(portfolios: { id: nil }).references(:portfolios) }

  validates :username, uniqueness: { case_sensitive: true }, format: { with: /^[a-zA-Z0-9_\.]*$/, multiline: true }, presence: true
  validates :slug, uniqueness: { case_sensitive: true }
  validate :username_against_inaccessible_words
  validate :email_against_username

  before_validation :adjust_slug, on: :update, if: proc { |m| m.username_changed? }

  before_save :valid_two_factor_confirmation

  attr_accessor :login

  def need_two_factor_authentication?(request)
    two_factor_enabled? && !unconfirmed_two_factor?
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

  def valid_two_factor_confirmation
    return true unless two_factor_just_set || phone_changed_with_two_factor
    self.unconfirmed_two_factor = true
  end

  def two_factor_just_set
    two_factor_enabled? && two_factor_enabled_changed?
  end

  def phone_changed_with_two_factor
    two_factor_enabled? && phone_changed?
  end

  def adjust_slug
    self.slug = username
  end
end
