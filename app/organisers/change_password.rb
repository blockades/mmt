# frozen_string_literal: true

class ChangePassword
  include Interactor::Organizer

  organize Authentication::Password, Authentication::TwoFactor, UpdatePassword
end
