# frozen_string_literal: true

module Command
  module Transaction
    class Withdraw < Command::Base
      attr_accessor :source_coin_id,
                    :source_quantity,
                    :member_id

      validates :source_coin_id,
                :source_quantity,
                :member_id,
                presence: true

      validates :source_quantity,
                numericality: { greater_than: 0 }

      def ensure_less_than_balance
        member = ::Member.find member_id
        return if member && source_quantity < member.holdings(coin_id)
        errors.add :quantity, "Not enough funds"
      end
    end
  end
end
