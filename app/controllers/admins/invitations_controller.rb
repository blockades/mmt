# frozen_string_literal: true

module Admins
  class InvitationsController < Devise::InvitationsController
    before_action :verify_admin, except: [:edit, :update]
    layout 'application', only: [:index, :new]

    def create
      member = Member.invite! invitation_params

      redirect_to new_member_invitation_path, notice: "Invitation sent to #{member.email}"
    end

    private

    def invitation_params
      params.require(:member).permit(:email, :password, :password_confirmation)
    end
  end
end
