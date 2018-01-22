# frozen_string_literal: true

module Events
  class Base < ApplicationRecord
    include ReadOnlyModel

    self.table_name = "events"
    self.store_full_sti_class = false

    belongs_to :coin
    belongs_to :member
    belongs_to :system_transaction, class_name: "Transactions::Base",
                                    foreign_key: :system_transaction_id

    scope :credit, -> { where(arel_table[:entry].gt(0)) }
    scope :debit, -> { where(arel_table[:entry].lt(0)) }
    scope :with_coin, ->(coin_id) { where coin_id: coin_id }
    scope :with_coins, -> { joins(:coin) }
    scope :crypto, -> { with_coins.merge(Coin.crypto) }
    scope :fiat, -> { with_coins.merge(Coin.fiat) }

    TYPES = %w[Equity Asset Liability].freeze

    validates :type, presence: true, inclusion: { in: TYPES }

    validates_associated :coin, :member

    def btc_value
      entry * rate
    end

    def btc_value_display
      Utils.to_decimal(btc_value, coin.subdivision).round(Coin::BTC_SUBDIVISION)
    end

    def self.total
      sum(:entry)
    end
  end
end