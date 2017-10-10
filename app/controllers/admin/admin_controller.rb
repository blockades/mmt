# frozen_string_literal: true

module Admin
  class AdminController < ApplicationController
    before_action :verify_admin
  end
end
