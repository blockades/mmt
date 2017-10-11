# frozen_string_literal: true

module Members
  class MembersController < ApplicationController
    def index
      @members = Member.all
    end
  end
end
