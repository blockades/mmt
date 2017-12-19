# frozen_string_literal: true

module Events
  class Asset < Events::Base
    alias_attribute :assets, :entry

    validates :assets,
              presence: true,
              numericality: { only_integer: true }

    validate :coin_assets

    private

    def coin_assets
      return true if assets.positive?
      system_assets = (coin.assets - assets.abs)
      return true if system_assets.positive? || system_assets.zero?
      self.errors.add :assets, "Insufficient assets"
    end
  end
end
