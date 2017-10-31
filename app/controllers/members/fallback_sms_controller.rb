# frozen_string_literal: true

module Members
  class FallbackSmsController < ApplicationController
    before_action :reauthenticate_member!

    def new
    end

  end
end
