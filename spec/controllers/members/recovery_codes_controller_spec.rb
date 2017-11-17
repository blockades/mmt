# frozen_string_literal: true

require 'rails_helper'

describe Members::RecoveryCodesController, type: :controller do
  let(:portfolio) { create :portfolio }
  let(:member) { portfolio.member }

  before do
    sign_in member
    reauthenticate!
    member.update otp_recovery_codes: member.generate_otp_recovery_codes
  end

  describe 'GET show' do
    let(:get_show) { get :show }

    it "returns a 200" do
      get_show
      expect(response.status).to eq 200
    end

    it 'assigns @member' do
      expect{ get_show }.to change{ assigns :member }
    end

    it 'renders the setup template' do
      expect(get_show).to render_template :show
    end
  end
end
