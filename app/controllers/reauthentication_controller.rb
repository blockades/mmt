# frozen_string_literal

class ReauthenticationController < ApplicationController
  include ReauthenticationHelper

  def new
    render 'devise/sessions/reauthenticate'
  end

  def create
    return unless current_member.valid_password?(permitted_params[:password])
    session[:reauthenticated_at] = Time.now
    redirect_to after_reauthenticate_path
  end

  private

  def permitted_params
    params.require(:member).permit(:password)
  end
end
