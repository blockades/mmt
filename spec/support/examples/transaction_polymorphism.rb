# frozen_string_literal: true

RSpec.shared_examples "source is a coin" do
  let(:coin) { create :coin }
  let(:member) { create :member }

  describe "source" do
    it "must be a Coin" do
      subject.source = coin
      expect(subject).to be_valid
    end

    it "cannot be a Member" do
      subject.source = member
      expect(subject).to_not be_valid
    end
  end
end

RSpec.shared_examples "source is a member" do
  let(:coin) { create :coin }
  let(:member) { create :member }

  describe "source" do
    it "must be a Member" do
      subject.source = member
      expect(subject).to be_valid
    end

    it "cannot be a Coin" do
      subject.source = coin
      expect(subject).to_not be_valid
    end
  end
end

RSpec.shared_examples "destination is a member" do
  let(:coin) { create :coin }
  let(:member) { create :member }

  describe "destination" do
    it "must be a Member" do
      subject.destination = member
      expect(subject).to be_valid
    end

    it "cannot be a Member" do
      subject.destination = member
      expect(subject).to_not be_valid
    end
  end
end

RSpec.shared_examples "destination is a member" do
  let(:coin) { create :coin }
  let(:member) { create :member }

  describe "destination" do
    it "must be a Member" do
      subject.destination = member
      expect(subject).to be_valid
    end

    it "cannot be a Coin" do
      subject.destination = coin
      expect(subject).to_not be_valid
    end
  end
end

RSpec.shared_examples "destination is a coin" do
  let(:coin) { create :coin }
  let(:member) { create :member }

  describe "destination" do
    it "must be a Coin" do
      subject.destination = coin
      expect(subject).to be_valid
    end

    it "cannot be a Member" do
      subject.destination = member
      expect(subject).to_not be_valid
    end
  end
end
