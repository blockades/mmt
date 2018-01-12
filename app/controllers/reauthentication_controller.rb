# frozen_string_literal: true

class ReauthenticationController < ApplicationController
  include ReauthenticationHelper
  layout "devise"

  def new
    render "devise/sessions/reauthenticate"
  end

  def create
    result = Authentication::Password.call(member: current_member, password: permitted_params[:password])
    if result.success?
      session[:reauthenticated_at] = Time.current
      redirect_to after_reauthenticate_path, notice: result.message
    else
      redirect_to new_reauthentication_path, notice: result.message
    end
  end

  private

  def permitted_params
    params.require(:member).permit(:password)
  end
end
