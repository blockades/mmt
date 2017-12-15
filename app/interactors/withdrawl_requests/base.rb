# frozen_string_literal: true

module WithdrawlRequests
  class Base
    include Interactor

    def withdrawl_request_commiter
      return false unless block_given? && member.present? && withdrawl_request.present?

      ActiveRecord::Base.transaction do
        withdrawl_request.with_lock do
          withdrawl_request.last_touched_by = member
          yield
        end
      end
    end

    def transaction_commiter(klass, transaction_params)
      member.with_lock do
        klass.create(transaction_params)
      end
    end

    private

    def member
      context.member
    end

    def withdrawl_request
      context.withdrawl_request
    end
  end
end
