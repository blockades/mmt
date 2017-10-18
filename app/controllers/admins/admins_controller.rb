# frozen_string_literal: true

module Admins
  class AdminsController < ApplicationController
    before_action :verify_admin
    layout 'admin'
  end
end
