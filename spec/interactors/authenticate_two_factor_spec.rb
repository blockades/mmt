# frozen_string_literal: true

require 'rails_helper'

describe AuthenticateTwoFactor, type: :interactor do
  let(:member) { create :member, otp_delivery_method: 'sms', two_factor_enabled: true }
  let(:context) { AuthenticateTwoFactor.call(member: member, password_params: password_params) }

  describe '#call' do
    context "with two factor disabled" do
      let(:password_params) { { authentication_code: '123456' } }

      before do
        allow(member).to receive(:two_factor_enabled?).and_return(false)
      end

      it "succeeds" do
        expect(context).to be_a_success
      end

      it "returns a message" do
        expect(context.message).to eq "Two factor not enabled"
      end
    end

    context "with an invalid authentication code" do
      let(:password_params) { { authentication_code: '123456' } }

      it "fails" do
        expect(context).to be_a_failure
      end

      it "returns a message" do
        expect(context.message).to eq "Two factor authentication failed"
      end
    end

    context "with a valid authentication code" do
      before { member.create_direct_otp }

      let(:password_params) { { authentication_code: member.direct_otp } }

      it "succeeds" do
        expect(context).to be_a_success
      end

      it "returns a message" do
        expect(context.message).to eq "Succesfully authenticated"
      end
    end
  end
end
