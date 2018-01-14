# frozen_string_literal: true

describe TwoFactor::Disable, type: :interactor, two_factor: true do
  let(:member) { create :member }
  let(:context) { TwoFactor::Disable.call(member: member) }

  describe "#call" do
    context "with a valid member" do
      it "succeeds" do
        expect(context).to be_a_success
      end

      it "returns a flash message" do
        expect(context.message).to eq "Two factor authentication disabled"
      end
    end

    context "with an invalid member" do
      before do
        allow(member).to receive(:update!).and_return(false)
      end

      it "fails" do
        expect(context).to be_a_failure
      end

      it "returns a message" do
        expect(context.message).to eq "Failed to disable two factor authentication"
      end
    end
  end
end
