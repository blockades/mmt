# frozen_string_literal: true

module Members
  class DashboardController < ApplicationController
    def index
      @coins = Coin.all.decorate
      @transactions = [
        current_member.source_transactions.system_deposit,
        current_member.destination_transactions.system_deposit
      ].flatten
    end
  end
end
