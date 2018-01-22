require "rails_helper"

describe Admins::SystemTransactionsController, type: :controller do
  let(:member) { create :member, :admin }
  before { sign_in member }

  describe "#index" do
    let(:get_index) { get :index, xhr: true }

    it "returns a 200" do
      get_index
      expect(response.status).to eq 200
    end

    it "assigns @transactions" do
      expect{ get_index }.to change { assigns :transactions }
    end
  end
end
