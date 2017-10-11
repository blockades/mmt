# frozen_string_literal: true

module Admins
  class AdminsController < ApplicationController
    before_action :verify_admin
  end
end
