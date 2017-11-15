# frozen_string_literal: true

module Admins
  class WithdrawlRequestMailer < AdminMailer
    def pending(admin_id:, request_id:)
      @admin = Member.find(admin_id)
      @withdrawl_request = WithdrawlRequest.find(request_id)
      @member = @withdrawl_request.member
      @coin = @withdrawl_request.coin
      setup_email(@admin, I18n.t('withdrawl_request.admins.pending.title'))
    end

    def in_progress(admin_id:, request_id:)
      @admin = Member.find(admin_id)
      @withdrawl_request = WithdrawlRequest.find(request_id)
      @member = @withdrawl_request.member
      @coin = @withdrawl_request.coin
      setup_email(@admin, I18n.t('withdrawl_request.admins.in_progress.title'))
    end

    def confirmed(admin_id:, request_id:)
      @admin = Member.find(admin_id)
      @withdrawl_request = WithdrawlRequest.find(request_id)
      @member = @withdrawl_request.member
      @coin = @withdrawl_request.coin
      setup_email(@admin, I18n.t('withdrawl_request.admins.confirmed.title'))
    end

    def cancelled(admin_id:, request_id:)
      @admin = Member.find(admin_id)
      @withdrawl_request = WithdrawlRequest.find(request_id)
      @member = @withdrawl_request.member
      @coin = @withdrawl_request.coin
      setup_email(@admin, I18n.t('withdrawl_request.admins.cancelled.title'))
    end

    def completed(admin_id:, request_id:)
      @admin = Member.find(admin_id)
      @withdrawl_request = WithdrawlRequest.find(request_id)
      @member = @withdrawl_request.member
      @coin = @withdrawl_request.coin
      setup_email(@admin, I18n.t('withdrawl_request.admins.confirmed.title'))
    end
  end
end
