# frozen_string_literal: true

require "rails_helper"

describe TwoFactor::Confirm, type: :interactor, two_factor: true do
  let(:member) { create :member, otp_delivery_method: "app" }
  let(:context) { TwoFactor::Confirm.call(member: member, authentication_code: "123456") }

  describe "#call" do
    context "with a valid authentication code" do
      before do
        allow(member).to receive(:authenticate_otp).with("123456").and_return(true)
      end

      context "with a valid member" do
        it "succeeds" do
          expect(context).to be_a_success
        end

        it "returns a flash message" do
          expect(context.message).to eq "You have enabled two factor authentication"
        end
      end

      context "with an invalid member" do
        before do
          allow(member).to receive(:update!).and_return(false)
        end

        it "fails" do
          expect(context).to be_a_failure
        end

        it "returns a message" do
          expect(context.message).to eq "Failed to enable two factor authentication"
        end
      end
    end

    context "with an invalid authentication code" do
      before do
        allow(member).to receive(:authenticate_otp).with("123456").and_return(false)
      end

      it "fails" do
        expect(context).to be_a_failure
      end

      it "returns a message" do
        expect(context.message).to eq "Authentication code mismatch, please try again"
      end
    end
  end
end
