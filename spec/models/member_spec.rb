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
  end
end
