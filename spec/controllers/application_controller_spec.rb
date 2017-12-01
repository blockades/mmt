# frozen_string_literal: true

require "rails_helper"

describe ApplicationController, type: :controller do
  let(:member) { create :member }
  let(:admin) { create :member, :admin }

  describe "#verify_admin" do
    context "with admin privilege" do
      before { sign_in admin }

      it "returns nil" do
        expect(subject.send(:verify_admin)).to be_nil
      end
    end

    context "without admin privilege" do
      before { sign_in member }

      it "raises Forbidden" do
        expect { subject.send(:verify_admin) }.to raise_error(Forbidden).with_message("403 Forbidden")
      end
    end
  end

  describe "#not_found" do
    it "raises NotFound" do
      expect { subject.send(:not_found) }.to raise_error(NotFound).with_message("404 Not Found")
    end
  end
end
