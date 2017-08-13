require './spec/rails_helper'

describe PlansController do

  describe '#index' do
    let(:get_index) { get :index }

    it 'returns a 200' do
      get_index
      expect(response.status).to eq 200
    end

    it 'assigns @users' do
      expect{ get_index }.to change{ assigns :plans }
    end

    it 'renders the index template' do
      expect(get_index).to render_template :index
    end
  end

  describe '#new' do
    let(:get_new) { get :new }

    it 'returns a 200' do
      get_new
      expect(response.status).to eq 200
    end

    it 'assigns @user' do
      expect{ get_new }.to change{ assigns :plan }
    end

    it 'renders the new template' do
      expect(get_new).to render_template :new
    end
  end

  describe '#create' do
    let(:coin) { create :coin }
    let(:plan_params) { { name: Faker::Name.name, details_attributes: { '0' => { coin_id: coin.id, proportion: 50.00 }, '1' => { coin_id: coin.id, proportion: 50.00 } } } }
    let(:post_create) { post :create, params: { plan: plan_params } }

    it 'retusn a 302' do
      post_create
      expect(response.status).to eq 302
    end

    it 'creates a plan' do
      expect{ post_create }.to change{ Plan.count }.by 1
    end

    it 'creates multiple details' do
      expect{ post_create }.to change{ Detail.count }.by 2
    end
  end
end
