# frozen_string_literal: true

require "rails_helper"

describe TwoFactor::Setup, type: :interactor, two_factor: true do
  let(:member) { create :member }

  describe "#call" do
    context "authentication by application" do
      let(:context) do
        TwoFactor::Setup.call(
          member: member,
          setup_params: { otp_delivery_method: "app" }
        )
      end

      context "with a valid member" do
        it "is successful" do
          expect(context).to be_a_success
        end

        it "sets the otp_encrypted_secret_key" do
          expect { context }.to change { member.encrypted_otp_secret_key }.from(nil).to(/\w+/)
        end

        it "sets otp_recovery_codes" do
          expect { context }.to change { member.otp_recovery_codes }
        end

        it "renders a message" do
          expect(context.message).to eq <<-STRING.delete("\n").squish
            Setup authentication by Authenticator application.
            Please continue to confirm two factor authentication
          STRING
        end
      end

      context "with an invalid member" do
        before { allow(member).to receive(:update!).and_return(false) }

        it "fails" do
          expect(context).to be_a_failure
        end

        it "renders a message" do
          expect(context.message).to eq "Failed to setup two factor authentication. Please try again"
        end
      end
    end

    context "authentication by phone" do
      let(:context) do
        TwoFactor::Setup.call(
          member: member,
          setup_params: { otp_delivery_method: "sms", phone_number: "1234567890", country_code: "44" }
        )
      end

      context "with a valid member" do
        it "is successful" do
          expect(context).to be_a_success
        end

        it "sets the member's phone number" do
          expect { context }.to change { member.phone_number }.from(nil).to("1234567890")
        end

        it "sets the member's country code" do
          expect { context }.to change { member.country_code }.from(nil).to("44")
        end

        it "sets the member's direct otp code" do
          expect { context }.to change { member.direct_otp }.from(nil).to(/\d+/)
        end

        it "renders a message" do
          expect(context.message).to eq <<-STRING.delete("\n").squish
            Setup authentication by Short message service (SMS).
            Please continue to confirm two factor authentication
          STRING
        end
      end

      context "with an invalid member" do
        before { allow(member).to receive(:update!).and_return(false) }

        it "fails" do
          expect(context).to be_a_failure
        end

        it "renders a message" do
          expect(context.message).to eq "Failed to setup two factor authentication. Please try again"
        end
      end
    end

    context "with invalid authentication method" do
      let(:context) do
        TwoFactor::Setup.call(
          member: member,
          setup_params: { otp_delivery_method: "some random thing" }
        )
      end

      it "fails" do
        expect(context).to be_a_failure
      end

      it "renders a message" do
        expect(context.message).to eq "Invalid delivery method"
      end
    end
  end
end
