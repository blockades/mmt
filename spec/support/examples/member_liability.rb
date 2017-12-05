# frozen_string_literal: true

RSpec.shared_examples 'member with bitcoin' do |options|
  include_examples "with admin"
  include_examples "with member"

  before do
    create :system_allocation, source: bitcoin,
                               destination: member,
                               source_coin: bitcoin,
                               destination_coin: bitcoin,
                               destination_quantity: Utils.to_integer(options[:liability], bitcoin.subdivision),
                               destination_rate: bitcoin.btc_rate,
                               initiated_by: admin
  end
end

