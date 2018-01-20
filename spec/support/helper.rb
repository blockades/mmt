# frozen_string_literal: true

module SpecHelperMethods
  def reauthenticate!
    @request.session[:reauthenticated_at] = Time.current
  end

  def json_fixture(name)
    File.read(Rails.root.join("spec", "support", "fixtures", "#{name}.json"))
  end
end
