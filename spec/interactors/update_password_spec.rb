# frozen_string_literal: true

describe UpdatePassword, type: :interactor, two_factor: true do
  let(:random_password) { SecureRandom.hex }

  let(:context) do
    UpdatePassword.call(
      member: member,
      password_params: password_params
    )
  end

  describe "#call" do
    let(:member) { create :member }

    let(:password_params) do
      {
        password: random_password,
        password_confirmation: random_password,
      }
    end

    context "with a valid member" do
      it "succeeds" do
        expect(context).to be_a_success
      end

      it "updates the password" do
        expect { context }.to change { member.password }
      end

      it "returns a flash message" do
        expect(context.message).to eq "Succesfully updated password"
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
        expect(context.message).to eq "Failed to update password"
      end
    end
  end
end
