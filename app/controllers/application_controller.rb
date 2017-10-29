# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from Forbidden, with: :rescue_403
  rescue_from NotFound, with: :rescue_404

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_member!
  before_action :notify_otp_setup_incomplete?, if: proc { current_member && current_member.otp_setup_incomplete? && current_member.otp_secret_key.present? }

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :accept_invitation, keys: [:username, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: [:username, :email, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :account_update, keys: [:username, :email, :password, :password_confirmation]
  end

  private

  def verify_admin
    forbidden unless current_member&.admin?
  end

  def forbidden
    raise Forbidden.new, '403 Forbidden'
  end

  def not_found
    raise NotFound.new, '404 Not Found'
  end

  def rescue_404
    render file: 'public/404', status: 404, layout: false
  end

  def rescue_403
    render file: 'public/403', status: 403, layout: false
  end

  def notify_otp_setup_incomplete?
    flash[:alert] = "Two Factor authentcation setup is incomplete. #{view_context.link_to('Click here to complete setup', confirm_two_factor_path)}.".html_safe
  end
end
