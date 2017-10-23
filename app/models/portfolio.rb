# frozen_string_literal: true

class Portfolio < ApplicationRecord
  belongs_to :member
  belongs_to :next_portfolio, class_name: "Portfolio", optional: true
  has_many :holdings, inverse_of: :portfolio
  has_one :previous_portfolio, class_name: "Portfolio", foreign_key: :next_portfolio_id

  scope :live, -> { where next_portfolio_id: nil }
  scope :with_member, -> { includes(:member) }

  validates_associated :holdings
  validates :state, inclusion: { in: [ 'finalised', 'expired', 'draft' ] }

  accepts_nested_attributes_for :holdings, reject_if: proc { |attributes| attributes[:quantity].blank? }
  attr_readonly :member_id, :portfolio_id

  def next_portfolio=(new_next_portfolio)
    return if !new_next_portfolio || next_portfolio_id
    new_next_portfolio.member = member
    self.class.transaction do
      update(next_portfolio_at: Time.current)
      update(next_portfolio_id: new_next_portfolio.tap(&:save).id)
    end
  end

  def btc_value
    holdings.to_a.sum(&:btc_value)
  end

  def initial_btc_value
    holdings_table = Holding.arel_table
    holdings.sum(holdings_table[:initial_btc_rate] * holdings_table[:quantity])
  end

  def previous_portfolio_id; end
end
