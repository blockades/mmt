# frozen_string_literal: true

module Events
  class Equity < Event
    alias_attribute :equity, :entry

    belongs_to :member, required: true

    validates :equity,
              presence: true,
              numericality: { only_integer: true }

    validates_associated :coin, :member

    validate :coin_equity

    private

    def coin_equity
      return true if (coin.assets - equity.abs).positive?
      self.errors.add :assets, "Insufficient equity"
    end
  end
end
