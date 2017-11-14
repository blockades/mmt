# frozen_string_literal: true

module Admins
  class WithdrawlRequestsController < AdminsController
    before_action :find_withdrawl_request, except: [:index]

    def index
      @withdrawl_requests = WithdrawlRequest.outstanding
    end

    def history
      if @withdrawl_requests = WithdrawlRequest.all
        head :ok
      else
        head 403
      end
    end

    def progress
      if @withdrawl_request.progress!(current_member.id)
        head :ok
      else
        head 403
      end
    end

    def confirm
      if @withdrawl_request.confirm!(current_member.id)
        head :ok
      else
        head 403
      end
    end

    def cancel
      if @withdrawl_request.cancel!(current_member.id)
        head :ok
      else
        head 403
      end
    end

    private

    def find_withdrawl_request
      @withdrawl_request = WithdrawlRequest.find params[:id]
    end
  end
end
