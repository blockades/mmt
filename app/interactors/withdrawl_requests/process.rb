# frozen_string_literal: true

module WithdrawlRequests
  class Process < Base
    def call
      context.fail!(message: "Failed") unless withdrawl_request.can_process?

      processed = withdrawl_request_commiter do
        withdrawl_request.processed_by = member
        withdrawl_request.process!
      end

      if processed
        context.message = "Success"
      else
        context.fail!(message: "Failed")
      end
    end
  end
end
