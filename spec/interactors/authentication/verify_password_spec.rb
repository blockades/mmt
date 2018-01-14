# frozen_string_literal: true

require "rails_helper"

describe Authentication::VerifyPassword, type: :interactor do
  let(:member) { create :member }
  let(:password) { SecureRandom.hex }

  describe "#call" do
    context "with a valid password" do
      let(:context) { Authentication::VerifyPassword.call(member: member, password: "password") }

      it "succeeds" do
        expect(context).to be_a_success
      end
    end

    context "with an invalid password" do
      let(:context) { Authentication::VerifyPassword.call(member: member, password: password) }

      it "fails" do
        expect(context).to be_a_failure
      end
    end
  end
end
