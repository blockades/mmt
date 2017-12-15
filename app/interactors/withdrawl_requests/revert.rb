# frozen_string_literal: true

module WithdrawlRequests
  class Revert < Base
    def call
      context.fail!(message: "Failed") unless withdrawl_request.can_revert?

      reverted = withdrawl_request_commiter do
        withdrawl_request.revert!
      end

      if reverted
        context.message = "Success"
      else
        context.fail!(message: "Failed")
      end
    end
  end
end
