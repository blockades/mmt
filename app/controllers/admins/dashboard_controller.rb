# frozen_string_literal: true

module Admins
  class DashboardController < AdminsController
    def index
      @transactions = Transactions::SystemDeposit.all
    end
  end
end
