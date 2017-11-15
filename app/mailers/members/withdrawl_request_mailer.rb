# frozen_string_literal: true

module Members
  class WithdrawlRequestMailer < MemberMailer
    def pending(request_id:)
      @withdrawl_request = WithdrawlRequest.find(request_id)
      @member = @withdrawl_request.member
      @coin = @withdrawl_request.coin
      setup_email(@member, I18n.t('withdrawl_request.members.pending.title'))
    end

    def in_progress(request_id:)
      @withdrawl_request = WithdrawlRequest.find(request_id)
      @member = @withdrawl_request.member
      @coin = @withdrawl_request.coin
      setup_email(@member, I18n.t('withdrawl_request.members.in_progress.title'))
    end

    def cancelled(request_id:)
      @withdrawl_request = WithdrawlRequest.find(request_id)
      @member = @withdrawl_request.member
      @coin = @withdrawl_request.coin
      setup_email(@member, I18n.t('withdrawl_request.members.cancelled.title'))
    end

    def completed(request_id:)
      @withdrawl_request = WithdrawlRequest.find(request_id)
      @member = @withdrawl_request.member
      @coin = @withdrawl_request.coin
      setup_email(@member, I18n.t('withdrawl_request.members.confirmed.title'))
    end
  end
end

