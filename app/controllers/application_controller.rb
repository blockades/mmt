# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from Forbidden, with: :rescue_403
  rescue_from NotFound, with: :rescue_404

  before_action :authenticate_member!

  private

  def forbidden
    raise Forbidden.new, '403 Forbidden'
  end

  def not_found
    raise NotFound.new, '404 Not Found'
  end

  def rescue_404
    redirect_to 'https://http.cat/404'
  end

  def rescue_403
    redirect_to 'https://http.cat/403'
  end
end
