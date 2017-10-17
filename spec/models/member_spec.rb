# frozen_string_literal: true

require 'rails_helper'

describe Member, type: :model do
  let(:member) { create :member }

  include_examples 'devise authenticatable with username or email', Member
  it_behaves_like 'sluggable', :username
end
