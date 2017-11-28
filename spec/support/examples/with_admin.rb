# frozen_string_literal: true

RSpec.shared_examples 'with admin' do
  let(:admin) { create :member, admin: true }
end
