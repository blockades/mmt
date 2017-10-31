# frozen_string_literal: true

module Members
  class SettingsController < ApplicationController
    before_action :decorate_member

    def index

    end

    private

    def decorate_member
      @member = current_member.decorate
    end

  end
end
