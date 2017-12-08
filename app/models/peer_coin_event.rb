class PeerCoinEvent < ApplicationRecord
  include Eventable

  belongs_to :coin
  belongs_to :member
  belongs_to :system_transaction

  validates :equity,
            presence: true,
            numericality: { only_integer: true }

  validates_associated :coin, :member

  validate :coin_equity

  def self.accounting_column
    :equity
  end

  private

  def coin_equity
  end
end
