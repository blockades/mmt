# frozen_string_literal: true

RSpec.shared_examples "system with bitcoin" do |options|
  include_examples "with admin"
  include_examples "with bitcoin"

  before do
    create :system_deposit, source: admin,
                            destination: bitcoin,
                            destination_quantity: Utils.to_integer(options[:assets], bitcoin.subdivision)
  end
end

RSpec.shared_examples "system with sterling" do |options|
  include_examples "with admin"
  include_examples "with sterling"

  before do
    create :system_deposit, source: admin,
                            destination: sterling,
                            destination_quantity: Utils.to_integer(options[:assets], sterling.subdivision)
  end
end
