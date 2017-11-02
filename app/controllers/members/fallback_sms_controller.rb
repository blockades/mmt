# frozen_string_literal: true

module Members
  class FallbackSmsController < ApplicationController
    before_action :reauthenticate_member!
    before_action :decorate_member

    def new
    end

    private

    def decorate_member
      @member = current_member.decorate
    end
  end
end
