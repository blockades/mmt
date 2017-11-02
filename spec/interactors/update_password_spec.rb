# frozen_string_literal: true

describe UpdatePassword, type: :interactor, two_factor: true do
  let(:random_password) { SecureRandom.hex }

  let(:context) do
    UpdatePassword.call(
      member: member,
      password_params: password_params
    )
  end

  describe '#call' do
    context 'without two factor authentication' do
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
          expect{ context }.to change{ member.password }
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

    context "with two factor authentication" do
      let(:member) { create :member, otp_delivery_method: 'sms', two_factor_enabled: true }

      context "without entering an authentication code" do
        let(:password_params) do
          {
            password: random_password,
            password_confirmation: random_password,
          }
        end

        it "fails" do
          expect(context).to be_a_failure
        end

        it "returns a message" do
          expect(context.message).to eq "Two factor authentication required. Please enter a code"
        end
      end

      context "with an invalid authentication code" do
        let(:password_params) do
          {
            password: random_password,
            password_confirmation: random_password,
            authentication_code: '123456'
          }
        end

        it "fails" do
          expect(context).to be_a_failure
        end

        it "returns a message" do
          expect(context.message).to eq "Two factor authentication failed"
        end
      end

      context "with a valid authentication code" do
        before { member.create_direct_otp }

        let(:password_params) do
          {
            password: random_password,
            password_confirmation: random_password,
            authentication_code: member.direct_otp
          }
        end

        it "succeeds" do
          expect(context).to be_a_success
        end

        it "updates the password" do
          expect{ context }.to change{ member.password }
        end

        it "returns a flash message" do
          expect(context.message).to eq "Succesfully updated password"
        end
      end
    end
  end
end

