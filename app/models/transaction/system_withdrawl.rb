# frozen_string_literal: true

module Transaction
  class SystemWithdrawl < Transaction::Base

    validates :source_coin,
              :source_quantity,
              :source_member,
              presence: true

    validates :source_quantity, numericality: { greater_than: 0 }

    validates_absence_of :destination_quantity,
                         :destination_rate,
                         :destination_coin,
                         :destination_member

  end
end
