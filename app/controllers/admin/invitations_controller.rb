module Admin
  class InvitationsController < Devise::InvitationsController
    before_action :verify_admin, except: [:edit, :update]
    layout 'application', only: [:index, :new]

    def index
      @not_accepted = Member.invitation_not_accepted
      @recently_accepted = Member.invitation_accepted
    end

    def create
      member = Member.invite! invitation_params
      redirect_to admin_members_path, notice: "Invitation sent to #{member.email}"
    end

    private

    def invitation_params
      params.require(:member).permit(:email, :password, :password_confirmation)
    end
  end
end
