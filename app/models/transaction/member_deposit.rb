# frozen_string_literal: true

module Transaction
  class MemberDeposit < Transaction::Base

    validates :destination_coin,
              :destination_quantity,
              :source_member,
              presence: true

    validates :destination_quantity,
              numericality: { greater_than: 0 }

    validates_absence_of :source_coin,
                         :source_rate,
                         :source_quantity,
                         :destination_rate,
                         :destination_member

  end
end
