# frozen_string_literal: true

module Members
  class RecoveryCodesController < ApplicationController
    before_action :reauthenticate_member!

    def index
      @recovery_codes = current_member.otp_recovery_codes
    end

  end
end
