class Portfolio < ApplicationRecord
  belongs_to :user
  belongs_to :next_portfolio, class_name: 'Portfolio', optional: true
  has_many :holdings
  has_one :previous_portfolio, class_name: 'Portfolio', foreign_key: :next_portfolio_id

  scope :live, -> { where next_portfolio_id: nil }

  validates_associated :holdings

  attr_readonly :user_id, :portfolio_id

  def next_portfolio=(new_next_portfolio)
    return if !new_next_portfolio || next_portfolio_id
    self.class.transaction do
      update(next_portfolio_at: Time.current)
      update(next_portfolio_id: new_next_portfolio.tap(&:save).id)
    end
  end

  def btc_value
    holdings.to_a.sum(&:btc_value)
  end
end
