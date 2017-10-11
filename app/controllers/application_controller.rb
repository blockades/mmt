# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from Forbidden, with: :rescue_403
  rescue_from NotFound, with: :rescue_404

  before_action :authenticate_member!

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
end
