# frozen_string_literal: true

module Events
  class Liability < Events::Base
    alias_attribute :liability, :entry

    validates :liability, presence: true,
                          numericality: { only_integer: true }

    validate :coin_assets, :member_coin_liability

    private

    def coin_assets
      return true if (coin.assets - liability.abs).positive?
      self.errors.add :assets, "Insufficient assets"
    end

    def member_coin_liability
      return true if liability.positive?
      member_liability = member.liability(coin) - liability.abs
      return true if member_liability.positive? || member_liability.zero?
      self.errors.add :liability, "Insufficient funds"
    end
  end
end
