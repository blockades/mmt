# frozen_string_literal: true

module Eventable
  extend ActiveSupport::Concern

  included do
    def readonly?
      ENV["READONLY_TRANSACTIONS"] == "false" ? false : !new_record?
    end

    scope :forward, -> { order(created_at: :asc) }
    scope :backward, -> { order(created_at: :desc) }
    scope :forward_from, ->(event) { forward.where("created_at >= ?", event.created_at) }
    scope :backward_from, ->(event) { backward.where("created_at <= ?", event.created_at) }

    scope :with_coin, ->(coin_id) { where coin_id: coin_id }
    scope :with_coins, -> { joins(:coin) }
    scope :crypto, -> { with_coins.merge(Coin.crypto) }
    scope :fiat, -> { with_coins.merge(Coin.fiat) }

    validate :system_sum_to_zero

    def credit?
      self.send(self.class.accounting_column).positive?
    end

    def debit?
      self.send(self.class.accounting_column).negative?
    end

    def system_liability
      MemberCoinEvent.sum(:liability)
    end

    def system_equity
      PeerCoinEvent.sum(:equity)
    end

    def system_assets
      CoinEvent.sum(:assets)
    end

    class << self
      def credit
        where("#{accounting_column} > 0")
      end

      def debit
        where("#{accounting_column} < 0")
      end
    end

    private

    def system_sum_to_zero
      return true if (system_liability + system_equity - system_assets).zero?
      self.errors.add :system_sum_to_zero, "Invalid transaction"
    end
  end
end
