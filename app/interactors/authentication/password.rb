# frozen_string_literal: true

module Authentication
  class Password
    include Interactor

    def call
      if member.valid_password?(password)
        context.message = "Successfully authenticated"
      else
        context.fail!(message: "Incorrect password")
      end
    end

    private

    def member
      context.member
    end

    def password
      context.password
    end
  end
end
