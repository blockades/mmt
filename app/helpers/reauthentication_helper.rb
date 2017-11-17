# frozen_string_literal: true

module ReauthenticationHelper
  def resource_name
    :member
  end

  def resource
    @resource ||= Member.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:member]
  end

  def after_reauthenticate_path
    session[:return_paths].reject do |path|
      path == request.fullpath
    end.pop(2).first || root_path
  end
end
