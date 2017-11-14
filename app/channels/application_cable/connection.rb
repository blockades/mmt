# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_member

    def connect
      self.current_member = find_verified_member
    end

    private

    def find_verified_member
      if verified_member = Member.find_by(id: cookies.encrypted[:member_id])
        verified_member
      else
        reject_unauthorized_connection
      end
    end
  end
end
