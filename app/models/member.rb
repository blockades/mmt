# frozen_string_literal: true

class Member < ApplicationRecord
  devise :invitable, :database_authenticatable, :recoverable,
    :rememberable, :trackable, :validatable, authentication_keys: [:login]

  has_one :live_portfolio, -> { live }, foreign_key: :member_id, class_name: "Portfolio"
  has_many :portfolios
  has_many :holdings, through: :live_portfolio

  scope :no_portfolio, -> { includes(:live_portfolio).where(portfolios: { id: nil }).references(:portfolios) }

  validates :username, uniqueness: { case_sensitive: false }, format: { with: /^[a-zA-Z0-9_\.]*$/, multiline: true }
  validate :email_against_username

  attr_accessor :login

  class << self
    def find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase  }]).first
      elsif conditions.has_key?(:username) || conditions.has_key?(:email)
        where(conditions.to_h).first
      end
    end
  end

  private

  def email_against_username
    if Member.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end
end
