# frozen_string_literal: true

class Member < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :live_portfolio, -> { live }, foreign_key: :member_id, class_name: "Portfolio"
  has_many :portfolios
  has_many :holdings, through: :live_portfolio

  scope :no_portfolio, -> { includes(:live_portfolio).where(portfolios: { id: nil }).references(:portfolios) }
end
