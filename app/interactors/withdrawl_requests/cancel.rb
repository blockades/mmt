# frozen_string_literal: true

module WithdrawlRequests
  class Cancel < Base
    def call
      context.fail!(message: "Failed") unless withdrawl_request.can_cancel?

      cancelled = withdrawl_request_commiter do
        withdrawl_request.cancelled_by = member
        withdrawl_request.cancel!
      end

      if cancelled
        context.message = "Success"
      else
        context.fail!(message: "Failed")
      end
    end
  end
end
