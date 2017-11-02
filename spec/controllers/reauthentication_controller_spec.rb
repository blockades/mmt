# frozen_string_literal: true

require 'rails_helper'

describe ReauthenticationController, type: :controller do
  let(:member) { create :member }

  before { sign_in member }

  describe 'GET new' do
    let(:get_new) { get :new }

    it 'returns a 200' do
      get_new
      expect(response.status).to eq 200
    end

    it 'returns a 200' do
      expect(get_new).to render_template 'devise/sessions/reauthenticate'
    end
  end

  describe 'POST create' do

    before do
      Timecop.freeze(Time.now)
      allow(request).to receive(:referer).and_return new_reauthentication_path
      @request.session[:return_paths] = [member_settings_two_factor_path]
    end

    after { Timecop.return }

    context "with valid password" do
      let(:post_create) { post :create, params: { member: { password: member.password } } }

      it "redirects to previous path" do
        expect(post_create).to redirect_to member_settings_two_factor_path
      end

      it "sets time of reauthentication to session" do
        post_create
        expect(@request.session[:reauthenticated_at]).to eq Time.now
      end
    end

    context "with invalid password" do
      let(:post_create) { post :create, params: { member: { password: '123456' } } }

      it "redirects back to new" do
        expect(post_create).to redirect_to new_reauthentication_path
      end
    end
  end
end
