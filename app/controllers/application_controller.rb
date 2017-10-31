# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from Forbidden, with: :rescue_403
  rescue_from NotFound, with: :rescue_404

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_member!
  before_action :store_return_paths

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

  def reauthenticate_member!
    unless session[:reauthenticated_at] && session[:reauthenticated_at] > 30.minutes.ago
      redirect_to new_reauthentication_path, notice: "Enter password to proceed"
    end
  end

  def store_return_paths
    session[:return_paths] ||= []
    session[:return_paths].shift if session[:return_paths].count >= 5
    if !devise_controller? && request.get? && (request.fullpath != session[:return_paths].last)
      session[:return_paths] << request.fullpath
    end
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
end
