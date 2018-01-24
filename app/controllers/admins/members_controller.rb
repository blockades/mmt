# frozen_string_literal: true

module Admins
  class MembersController < AdminsController
    before_action :find_member, only: [:show]

    def index
      @members = Member.all
      @member = Member.new
    end

    def show
      respond_to do |format|
        format.json { render json: @member.as_json(only: [:id]) }
      end
    end

    def create
      member = Member.new permitted_params
      if member.save
        redirect_to action: :index, notice: "Member created"
      else
        flash[:alert] = "Member failed to be created"
        render :new
      end
    end

    private

    def find_member
      @member = Member.friendly.find params[:id]
    end

    def permitted_params
      params.require(:member).permit :email, :password
    end
  end
end
