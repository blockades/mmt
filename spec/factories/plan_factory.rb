# frozen_string_literal: true

FactoryGirl.define do
  factory :plan do
    name Faker::Space.planet
    after(:build) do |plan|
      2.times { plan.details << create(:plan_detail, proportion: 50.00) }
    end
  end
end
