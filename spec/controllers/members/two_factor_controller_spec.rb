require 'rails_helper'

describe Members::TwoFactorController, type: :controller, two_factor: true do
  let(:portfolio) { create :portfolio }
  let(:member) { portfolio.member }

  before { sign_in member }

  describe 'setup' do
    describe '#GET_setup' do
      let(:get_setup) { get :GET_setup }

      it 'renders the setup template' do
        expect(get_setup).to render_template :GET_setup
      end
    end

    describe '#PATCH_setup' do
      let(:patch_setup) { patch :PATCH_setup }

    end
  end

  describe 'confirm' do
    before do
      member.setup_two_factor!
    end

    describe '#GET_confirm' do
      let(:get_confirm) { get :GET_confirm }

      it 'renders the confirm template' do
        expect(get_confirm).to render_template :GET_confirm
      end
    end

    describe '#PATCH_confirm' do
      let(:patch_confirm) { patch :PATCH_confirm }

    end

  end

  describe 'disable' do
    before do
      member.setup_two_factor!
      member.confirm_two_factor!
    end

    describe '#GET_disable' do

      let(:get_disable) { get :GET_disable }

      it 'renders the disable template' do
        expect(get_disable).to render_template :GET_disable
      end

    end

    describe '#PATCH_disable' do
      let(:patch_disable) { patch :PATCH_disable }

    end
  end

end
