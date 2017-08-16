class Portfolio < ApplicationRecord
  belongs_to :user
  belongs_to :next_portfolio, class_name: 'Portfolio', optional: true
  has_many :holdings
  has_one :previous_portfolio, class_name: 'Portfolio', foreign_key: :next_portfolio_id

  attr_readonly :user_id, :portfolio_id

  scope :live, -> { where next_portfolio_id: nil }
end
