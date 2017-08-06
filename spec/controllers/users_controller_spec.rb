require './spec/rails_helper'

describe UsersController do

  describe '#index' do
    let!(:get_index) { get :index }

    it 'returns a 200' do
      expect(response.status).to eq 200
    end

    it 'renders the index template' do
      expect(get_index).to render_template :index
    end
  end

end
