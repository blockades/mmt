# frozen_string_literal: true

module Members
  class MembersController < ApplicationController
    before_action :find_member, only: [:show, :edit]

    def index
      @members = Member.all
    end

    def show
    end

    private

    def find_member
      @member = params[:id] ? Member.find(params[:id]) : current_member
    end
  end
end
