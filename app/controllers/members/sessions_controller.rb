# frozen_string_literal: true

module Members
  class SessionsController < Devise::SessionsController

    def create
      super do |resource|
        cookies.encrypted[:member_id] = resource.id
      end
    end

    def destroy
      cookies.encrypted[:member_id] = nil
      super
    end

  end
end
