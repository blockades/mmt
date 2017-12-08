# frozen_string_literal: true

module Members
  class MembersController < ApplicationController
    before_action :find_member, only: [:show, :update]

    def show
    end

    def update
      respond_to do |format|
        if @member.update member_params
          format.html { redirect_to member_path(@member), notice: "Successfully updated" }
          format.json { render json: { success: true, member: @member } }
        else
          format.html { redirect_to member_path(@member), alert: "Failed to update" }
          format.json { render json: { success: false, errors: @member.errors, member: @member } }
        end
      end
    end

    private

    def find_member
      @member = Member.friendly.find(params[:id]).decorate
    end

    def member_params
      params.require(:member).permit(:username, :country_code, :phone_number)
    end

  end
end
