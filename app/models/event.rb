# frozen_string_literal: true

class Event < ApplicationRecord
  include InheritanceNamespace
  include ReadOnlyModel

  belongs_to :coin
  belongs_to :system_transaction
  belongs_to :member

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

  TYPES.each do |type|
    scope type.underscore.to_sym, -> { where type: type }

    define_method "#{type.underscore}?" do
      type == self.type
    end
  end

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
