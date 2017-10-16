# frozen_string_literal: true

FactoryGirl.define do
  factory :member do
    sequence(:email) { |n| "member_#{n}@example.com" }
    password "password"
    sequence(:username) { |n| "member_#{n}" }

    trait :admin do
      admin true
    end
  end
end
