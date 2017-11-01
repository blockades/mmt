require 'rails_helper'

describe Members::TwoFactorController, type: :controller, two_factor: true do
  let(:portfolio) { create :portfolio }
  let(:member) { portfolio.member }

  before do
    sign_in member
    @request.session[:reauthenticated_at] = Time.now
  end

  describe '#index' do
    let(:get_index) { get :index }

    it "returns a 200" do
      get_index
      expect(response.status).to eq 200
    end

    it 'assigns @member' do
      expect{ get_index }.to change{ assigns :member }
    end

    it 'renders the setup template' do
      expect(get_index).to render_template :index
    end
  end

  describe '#new' do
    let(:get_new) { get :new }

    context "after ConfirmedTwoFactorAuthentication" do
      before do
        allow(member).to receive(:two_factor_enabled?).and_return(true)
      end

      it "redirects to index" do
        expect(get_new).to redirect_to member_settings_two_factor_path
      end
    end

    context "two factor not enabled" do
      it "returns a 200" do
        get_new
        expect(response.status).to eq 200
      end

      it 'assigns @member' do
        expect{ get_new }.to change{ assigns :member }
      end

      it 'renders the setup template' do
        expect(get_new).to render_template :new
      end
    end
  end

  describe '#edit' do
    let(:get_edit) { get :edit }

    context 'after SetupTwoFactorAuthentication' do
      it "returns a 200" do
        get_edit
        expect(response.status).to eq 200
      end

      it 'assigns @member' do
        expect{ get_edit }.to change{ assigns :member }
      end

      it 'renders the setup template' do
        expect(get_edit).to render_template :edit
      end
    end

    context "before SetupTwoFactorAuthentication" do
      before do
        allow(member).to receive(:otp_secret_key).and_return(nil)
      end

      it "redirects to index" do
        expect(get_edit).to redirect_to member_settings_two_factor_path
      end
    end

    context "after ConfirmedTwoFactorAuthentication" do
      before do
        allow(member).to receive(:two_factor_enabled?).and_return(true)
      end

      it "redirects to index" do
        expect(get_edit).to redirect_to member_settings_two_factor_path
      end
    end
  end

  describe '#create' do

  end
end
