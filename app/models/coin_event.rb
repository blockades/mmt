# frozen_string_literal: true

class CoinEvent < ApplicationRecord

  belongs_to :coin

  def readonly?
    !new_record?
  end

  validates :liability,
            :available,
            :transaction_id,
            presence: true

  validates :liability,
            :available,
            numericality: { only_integer: true }

end
