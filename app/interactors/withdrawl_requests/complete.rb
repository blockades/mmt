# frozen_string_literal: true

module WithdrawlRequests
  class Complete < Base
    def call
      context.fail!(message: "Failed") unless withdrawl_request.can_complete?

      completed = withdrawl_request_commiter do
        transaction_commiter(Transactions::MemberWithdrawl, transaction_params)
        withdrawl_request.completed_by = member
        withdrawl_request.complete!
      end

      if completed
        context.message = "Success"
      else
        context.fail!(message: "Failed")
      end
    end

    private

    def transaction_params
      withdrawl_request.transaction_params.merge(
        previous_transaction: context.previous_transaction,
        initiated_by: withdrawl_request.member,
        authorized_by: member
      )
    end
  end
end
