# frozen_string_literal: true

class MembersController < ApplicationController
  def index
    @members = Member.all
  end
end
