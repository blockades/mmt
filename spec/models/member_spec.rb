# frozen_string_literal: true

require 'rails_helper'

describe Member, type: :model do
  let(:member) { create :member }

  it_behaves_like 'sluggable', :username

  include_examples 'devise authenticatable with username or email', Member

  describe 'two factor authentication' do
    describe '#otp_setup_complete' do
      it 'is complete when enabled and key present' do
        expect(member.otp_setup_complete?).to be_falsey
        member.update(otp_secret_key: 'woof', two_factor_enabled: true)
        expect(member.otp_setup_complete?).to be_truthy
      end
    end

    describe '#otp_setup_incomplete' do
      it 'is not when enabled and key present' do
        member.otp_secret_key = 'woof'
        expect(member.otp_setup_incomplete?).to be_truthy
        member.two_factor_enabled = true
        expect(member.otp_setup_incomplete?).to be_falsey
      end
    end

    describe '#need_two_factor_authentication?' do
      it 'is true only when setup process is complete' do
        member.two_factor_enabled = true
        expect(member.need_two_factor_authentication?(nil)).to be_falsey
        member.otp_secret_key = 'woof'
        member.two_factor_enabled = true
        expect(member.need_two_factor_authentication?(nil)).to be_truthy
      end
    end

    describe '#setup_two_factor' do
      it 'sets secret keys' do
        expect{ member.setup_two_factor! }.to change{ member.encrypted_otp_secret_key }
      end

      it 'sets recovery codes' do
        expect{ member.setup_two_factor! }.to change{ member.otp_recovery_codes }
      end
    end

    describe '#confirm_two_factor' do
      it 'sets two_factor_enabled to true' do
        expect{ member.confirm_two_factor!('app') }.to change{ member.two_factor_enabled }.from(false).to(true)
      end

      it 'sets otp_delivery_method' do
        expect{ member.confirm_two_factor!('app') }.to change{ member.otp_delivery_method }.from(nil).to('Authenticator application')
      end
    end

    describe '#disable_two_factor' do
      before do
        member.otp_secret_key = ENV["OTP_SECRET_ENCRYPTION_KEY"]
        member.otp_delivery_method = 'Authenticator application'
        member.two_factor_enabled = true
        member.save!
      end

      it 'resets otp_secret_key' do
        expect{ member.disable_two_factor! }.to change{ member.encrypted_otp_secret_key }.to nil
      end

      it 'resets two_factor_enabled' do
        expect{ member.disable_two_factor! }.to change{ member.two_factor_enabled }.from(true).to false
      end

      it 'resets otp_delivery_method' do
        expect{ member.disable_two_factor! }.to change{ member.otp_delivery_method }.from('Authenticator application').to nil
      end
    end
  end
end
