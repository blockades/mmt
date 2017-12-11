# frozen_string_literal: true

class Event < ApplicationRecord
  include InheritanceNamespace

  belongs_to :coin
  belongs_to :system_transaction
  belongs_to :member

  def readonly?
    ENV["READONLY_TRANSACTIONS"] == "false" ? false : !new_record?
  end

  scope :forward, -> { order(created_at: :asc) }
  scope :backward, -> { order(created_at: :desc) }
  scope :forward_from, ->(event) { forward.where("created_at >= ?", event.created_at) }
  scope :backward_from, ->(event) { backward.where("created_at <= ?", event.created_at) }

  scope :credit, -> { where("entry > 0") }
  scope :debit, -> { where("entry < 0") }
  scope :with_coin, ->(coin_id) { where coin_id: coin_id }
  scope :with_coins, -> { joins(:coin) }
  scope :crypto, -> { with_coins.merge(Coin.crypto) }
  scope :fiat, -> { with_coins.merge(Coin.fiat) }

  TYPES = %w[Equity Asset Liability].freeze

  validates :type, presence: true,
                   inclusion: { in: TYPES }

  validates_associated :coin, :member

  def credit?
    send(type).positive?
  end

  def debit?
    send(type).negative?
  end

  def system_liability
    Events::Liability.sum(:liability)
  end

  def system_equity
    Events::Equity.sum(:equity)
  end

  def system_assets
    Events::Asset.sum(:assets)
  end
end
