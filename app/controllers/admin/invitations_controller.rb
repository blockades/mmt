module Admin
  class InvitationsController < Devise::InvitationsController
    before_action :verify_admin
  end
end
