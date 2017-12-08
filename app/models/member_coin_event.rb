# frozen_string_literal: true

class MemberCoinEvent < ApplicationRecord
  include Eventable

  belongs_to :coin
  belongs_to :member
  belongs_to :system_transaction

  validates :liability, presence: true,
                        numericality: { only_integer: true }

  validates_associated :member

  validate :coin_assets, :member_coin_liability

  def self.accounting_column
    :liability
  end

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
