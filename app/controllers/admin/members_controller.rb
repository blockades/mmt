# frozen_string_literal: true

module Admin
  class MembersController < AdminController
    def index
      @members = Member.all
    end

    def new
      @member = Member.new
    end

    def edit

    end

    def create
      member = Member.new permitted_params
      if member.save
        flash[:success] = "Member created"
        redirect_to action: :index
      else
        flash[:error] = "Member failed to be created"
        render :new
      end
    end

    private

    def permitted_params
      params.require(:member).permit :email, :password
    end
  end
end

