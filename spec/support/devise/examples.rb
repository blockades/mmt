# frozen_string_literal: true

RSpec.shared_examples "devise authenticatable with username or email" do |const|
  let(:object) { send const.table_name.singularize }
  let(:simulate_login) { ->(warden_conditions) { const.find_for_database_authentication(warden_conditions) } }

  context "with :login condition" do
    context "with email as login" do
      it "returns the object for login authentication" do
        expect(simulate_login.call(login: object.email)).to eq object
      end
    end

    context "with username as login" do
      it "returns the object for login authentication" do
        expect(simulate_login.call(login: object.username)).to eq object
      end
    end
  end

  context "with :username condition" do
    it "returns the object for login authentication" do
      expect(simulate_login.call(username: object.username)).to eq object
    end
  end

  context "with :email condition" do
    it "returns the object for login authentication" do
      expect(simulate_login.call(email: object.email)).to eq object
    end
  end

  context "without conditions" do
    it "returns the object for login authentication" do
      expect(simulate_login.call({})).to be_nil
    end
  end
end
