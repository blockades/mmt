# frozen_string_literal: true

class ChangePassword
  include Interactor::Organizer

  organize AuthenticatePassword, AuthenticateTwoFactor, UpdatePassword
end
