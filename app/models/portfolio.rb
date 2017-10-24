# frozen_string_literal: true

class Portfolio < ApplicationRecord
  belongs_to :member
  belongs_to :next_portfolio, class_name: "Portfolio", optional: true
  has_many :assets, inverse_of: :portfolio
  has_one :previous_portfolio, class_name: "Portfolio", foreign_key: :next_portfolio_id

  scope :live, -> { finalised.where next_portfolio_id: nil }
  scope :with_member, -> { includes(:member) }

  scope :draft, -> { where state: 'draft' }
  scope :finalised, -> { where state: 'finalised' }
  scope :expired, -> { where state: 'expired' }

  scope :date_order, -> { order('next_portfolio_at DESC NULLS FIRST')  }

  validates_associated :assets
  validates :state, inclusion: { in: [ 'finalised', 'expired', 'draft' ] }

  accepts_nested_attributes_for :assets, reject_if: proc { |attributes| attributes[:quantity].blank? }
  attr_readonly :member_id, :portfolio_id

  def next_portfolio=(new_next_portfolio)
    return if !new_next_portfolio || next_portfolio_id
    new_next_portfolio.member = member
    self.class.transaction do
      update(next_portfolio_at: Time.current)
      update(next_portfolio_id: new_next_portfolio.tap(&:save).id)
      update(state: :expired)
      new_next_portfolio.update(state: :finalised)
    end
  end

  def btc_value
    assets.to_a.sum(&:btc_value)
  end

  def initial_btc_value
    assets_table = Asset.arel_table
    assets.sum(assets_table[:initial_btc_rate] * assets_table[:quantity])
  end

  def previous_portfolio_id; end
end
