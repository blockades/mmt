# frozen_string_literal: true

module Events
  class Equity < Events::Base
    alias_attribute :equity, :entry

    validates :equity,
              presence: true,
              numericality: { only_integer: true }

    validate :coin_equity

    private

    def coin_equity
      return true if equity.positive?
      actual_equity = (coin.equity - equity.abs)
      return true if actual_equity.positive? || actual_equity.zero?
      self.errors.add :equity, "Insufficient equity"
    end
  end
end
