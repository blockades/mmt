# frozen_string_literal: true

require './spec/rails_helper'

describe Member, type: :model do
  let(:member) { create :member }
  include_examples 'devise authenticatable with username or email', Member
end
