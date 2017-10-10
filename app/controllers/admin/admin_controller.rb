# frozen_string_literal: true

module Admin
  class AdminController < ApplicationController
    before_action :verify_admin

    private

    def verify_admin
      raise ActiveRecord::RecordNotFound unless current_member&.admin?
    end
  end
end
