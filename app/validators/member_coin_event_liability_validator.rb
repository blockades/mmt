# frozen_string_literal: true

module Validators
  class MemberCoinEventLiability < ActiveModel::Validator

    def validate(event)
      case event.triggered_by.type
      when "Transaction::SystemAllocation"
        return true
      when  "Transaction::SystemExchange"
        validate_system_exchange
      when  "Transaction::MemberAllocation"
        validate_member_allocation
      when  "Transaction::MemberDeposit"
        validate_member_deposit
      when  "Transaction::MemberWithdrawl"
        validate_member_withdrawl
      when "Transaction::MemberExchange"
        validate_member_exchange
      else
        event.errors.add :transaction, "Invalid transaction type"
      end
    end

    private

    def validate_system_exchange
      if event.triggered_by.destination_member == event.member
        return true if event.liability.abs < event.member.reload.liability(event.coin.id)
        event.errors.add :liability, "Insufficient funds"
      else
        return true
      end
    end

    def validate_member_allocation
      event.errors.add :null_functionality, "null functionality"
    end

    def validate_member_deposit
      event.errors.add :null_functionality, "null functionality"
    end

    def validate_member_withdrawl
      return true if event.liability.abs < event.member.reload.liability(event.coin.id)
    end

  end
end
