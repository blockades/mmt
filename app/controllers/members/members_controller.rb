# frozen_string_literal: true

module Members
  class MembersController < ApplicationController
    before_action :find_member, only: [:show, :update]
    before_action :authorize_member, only: [:update]

    def show
    end

    def update
      respond_to do |format|
        if @member.update member_params
          format.html { redirect_to member_path(@member), notice: "Successfully updated" }
          format.js { render :form }
          format.json { render json: { success: true, member: @member } }
        else
          format.html { redirect_to member_path(@member), alert: "Failed to update" }
          format.js { render :form }
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

    def authorize_member
      unless current_member == @member
        flash[:alert] = "Not permitted"
        render :show
      end
    end
  end
end
