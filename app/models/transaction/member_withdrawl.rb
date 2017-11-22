# frozen_string_literal: true

module Transaction
  class MemberWithdrawl < Transaction::Base

    validates :source_coin,
              :source_quantity,
              :destination_member,
              presence: true

    validates :source_quantity,
              numericality: { greater_than: 0 }

    validates_absence_of :source_member,
                         :source_rate,
                         :destination_coin,
                         :destination_quantity,
                         :destination_rate

    validate :destination_member_has_sufficient_source_coin

  end
end
