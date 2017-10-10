module Admin
  class InvitationsController < Devise::InvitationsController
    include Admin::AuthenticationHelper

    before_action :verify_admin
  end
end
