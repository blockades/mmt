# frozen_string_literal: true

class ChangePassword
  include Interactor::Organizer

  organize Authentication::VerifyPassword, Authentication::VerifyTwoFactor, UpdatePassword
end
