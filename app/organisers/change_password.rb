# frozen_string_literal: true

class ChangePassword
  include Interactor::Organizer

  organize AuthenticateMember, UpdatePassword
end
