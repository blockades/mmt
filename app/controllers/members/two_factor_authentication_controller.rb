# frozen_string_literal: true

module Members
  class TwoFactorAuthenticationController < ApplicationController

    def new
      respond_to do |format|
        format.js
      end
    end

  end
end
