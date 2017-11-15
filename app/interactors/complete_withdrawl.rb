# frozen_string_literal: true

class CompleteWithdrawl
  include Interactor

  def call
    raise WithdrawlError, "Cannot complete unconfirmed withdrawl" unless withdrawl_request.can_complete?
    context.fail!(message: "Failed") unless ActiveRecord::Base.transaction do

      # We decrease overall funds in the system
      adjustment = coin.reserves - withdrawl_request.quantity
      coin.publish!(Events::Coin::State, {
        holdings: coin.holdings,
        reserves: adjustment,
        transaction_id: withdrawl_request.transaction_id
      })

      # We decrease members holdings
      adjustment = member.holdings(coin.id) - withdrawl_request.quantity
      member.publish!(Events::Member::Balance, {
        coin_id: coin.id,
        holdings: adjustment,
        transaction_id: withdrawl_request.transaction_id
      })

      withdrawl_request.last_changed_by_id = withdrawl_request.confirmed_by.id
      withdrawl_request.completed_by_id = withdrawl_request.confirmed_by.id
      withdrawl_request.complete
    end
  rescue WithdrawlError => error
    withdrawl_request.crash
    context.fail!(message: error.message)
  end

  private

  def withdrawl_request
    @withdrawl_request ||= ::WithdrawlRequest.find context.withdrawl_request_id
  end

  def member
    @member ||= withdrawl_request.member
  end

  def coin
    @coin ||= withdrawl_request.coin
  end
end
