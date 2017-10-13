# frozen_string_literal: true

module Members
  class MembersController < ApplicationController
    before_action :find_member, only: [:show, :edit, :update]

    def index
      @members = Member.all
    end

    def show
    end

    def update
      respond_to do |format|
        if @member.update member_params
          format.html { redirect_to member_path(@member), notice: "Successfull updated" }
          format.json { render json: { success: true, member: @member }.to_json }
        else
          format.html { redirect_to member_path(@member), error: "Failed to update" }
          format.json { render json: { success: false, errors: @member.errors, member: @member }.to_json }
        end
      end
    end

    private

    def find_member
      @member = params[:id] ? Member.friendly.find(params[:id]) : current_member
    end

    def member_params
      params.require(:member).permit(:username)
    end
  end
end
