# frozen_string_literal: true

require "rails_helper"

describe Members::PasswordsController, type: :controller, two_factor: true do
  include_examples "with member"

  before do
    sign_in member
  end

  describe "GET new" do
    let(:get_new) { get :new }

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

  describe "PATCH update" do
    let(:random_password) { SecureRandom.hex }

    context "successful UpdatePassword" do
      let(:patch_update) do
        patch :update, params: {
          member: {
            current_password: "password",
            password: random_password,
            password_confirmation: random_password
          }
        }
      end

      it "redirects to the edit page" do
        expect(patch_update).to redirect_to member_path(member)
      end
    end

    context "failed UpdatePassword" do
      let(:patch_update) do
        patch :update, params: {
          member: {
            password: random_password,
            password_confirmation: random_password,
            authentication_code: "123456"
          }
        }
      end

      before { member.update!(two_factor_enabled: true, otp_delivery_method: "app") }

      it "redirects back" do
        expect(patch_update).to redirect_to new_member_settings_password_path
      end
    end
  end
end
