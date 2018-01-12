# frozen_string_literal: true

require "rails_helper"

describe Members::TwoFactorController, type: :controller, two_factor: true do
  include_examples "with member"

  before do
    sign_in member
    reauthenticate!
  end

  describe "GET index" do
    let(:get_index) { get :index }

    it "returns a 200" do
      get_index
      expect(response.status).to eq 200
    end

    it "assigns @member" do
      expect { get_index }.to change { assigns :member }
    end

    it "renders the setup template" do
      expect(get_index).to render_template :index
    end
  end

  describe "GET new" do
    let(:get_new) { get :new }

    context "before TwoFactor::Confirm" do
      it "returns a 200" do
        get_new
        expect(response.status).to eq 200
      end

      it "assigns @member" do
        expect { get_new }.to change { assigns :member }
      end

      it "renders the setup template" do
        expect(get_new).to render_template :new
      end
    end
  end

  describe "POST create" do
    context "successful TwoFactor::Setup" do
      let(:post_create) { post :create, params: { two_factor: { otp_delivery_method: "app" } } }

      it "redirects to the edit page" do
        expect(post_create).to redirect_to edit_member_settings_two_factor_path
      end
    end

    context "failed TwoFactor::Setup" do
      let(:post_create) { post :create, params: { two_factor: { otp_delivery_method: "bob" } } }

      it "redirects to the index page" do
        expect(post_create).to redirect_to member_settings_two_factor_path
      end
    end
  end

  describe "GET edit" do
    let(:get_edit) { get :edit }

    context "after TwoFactor::Setup" do
      before do
        member.update otp_secret_key: member.generate_totp_secret,
                      otp_recovery_codes: member.generate_otp_recovery_codes
      end

      it "returns a 200" do
        get_edit
        expect(response.status).to eq 200
      end

      it "assigns @member" do
        expect { get_edit }.to change { assigns :member }
      end

      it "renders the setup template" do
        expect(get_edit).to render_template :edit
      end
    end

    context "before TwoFactor::Setup" do
      before do
        allow(member).to receive(:otp_secret_key).and_return(nil)
      end

      it "redirects to index" do
        expect(get_edit).to redirect_to member_settings_two_factor_path
      end
    end

    context "after TwoFactor::Confirm" do
      before do
        allow(member).to receive(:two_factor_enabled?).and_return(true)
      end

      it "redirects to index" do
        expect(get_edit).to redirect_to member_settings_two_factor_path
      end
    end
  end

  describe "PATCH update" do
    context "successful TwoFactor::Confirm" do
      let(:patch_update) { patch :update, params: { two_factor: { code: member.direct_otp } } }

      before do
        member.create_direct_otp
        member.update otp_delivery_method: "app"
      end

      it "redirects to the edit page" do
        expect(patch_update).to redirect_to member_settings_two_factor_path
      end
    end

    context "failed TwoFactor::Confirm" do
      let(:patch_update) { patch :update, params: { two_factor: { code: "123456" } } }

      before { allow(member).to receive(:authenticate_otp).and_return(false) }

      it "redirects to the index page" do
        expect(patch_update).to redirect_to new_member_settings_two_factor_path
      end
    end
  end

  describe "DELETE destroy" do
    let(:delete_destroy) { delete :destroy }

    it "redirects to the index page" do
      expect(delete_destroy).to redirect_to member_settings_two_factor_path
    end
  end

  describe "GET resend_code" do
    let(:get_resend_code) { get :resend_code, xhr: true }
    let(:json_response) { JSON.parse(response.body) }

    context "outside nonce timestamp" do
      it "renders a JSON response" do
        get_resend_code
        expect(json_response).to eq("success" => true, "message" => "Two factor code sent")
      end
    end

    context "within nonce timestamp" do
      before do
        @request.session[:resend_two_factor_code] = nonce(Time.current)
      end

      it "renders a JSON response" do
        get_resend_code
        expect(json_response).to eq("success" => false, "message" => "Wait 5 minutes before requesting another code")
      end
    end
  end
end
