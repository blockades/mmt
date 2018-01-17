require "rails_helper"

describe WithdrawlRequest, type: :model do
  include_examples "system with bitcoin", assets: 2
  include_examples "member with bitcoin", liability: 1

  let(:withdrawl_request) do
    create :withdrawl_request, coin: bitcoin,
                               member: member,
                               last_changed_by: member
  end

  describe "state transitions" do
    it "make your transition (valid transitions)" do
      # https://www.youtube.com/watch?v=9Kd4AKKSn4w
      expect(withdrawl_request).to have_state(:pending)
      expect(withdrawl_request).to transition_from(:pending).to(:processing).on_event(:process!, { member: member })
      expect(withdrawl_request).to transition_from(:pending).to(:cancelled).on_event(:cancel!, { member: member })
      expect(withdrawl_request).to transition_from(:pending).to(:cancelled).on_event(:cancel!, { member: member })
      expect(withdrawl_request).to transition_from(:processing).to(:completed).on_event(:complete!, { member: member })
      expect(withdrawl_request).to transition_from(:pending).to(:failed).on_event(:fail!, { member: member })
      expect(withdrawl_request).to transition_from(:processing).to(:failed).on_event(:fail!, { member: member })
    end

    it "invalid transitions" do
      expect(withdrawl_request).to_not transition_from(:pending).to(:complete)
      expect(withdrawl_request).to_not transition_from(:processing).to(:pending)
      expect(withdrawl_request).to_not transition_from(:processing).to(:cancelled)
      expect(withdrawl_request).to_not transition_from(:cancelled).to(:complete)
      expect(withdrawl_request).to_not transition_from(:cancelled).to(:processing)
      expect(withdrawl_request).to_not transition_from(:cancelled).to(:pending)
    end
  end
end
