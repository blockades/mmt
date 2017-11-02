# frozen_string_literal: true

FactoryBot.define do
  factory :member do
    sequence(:email) { |n| "member_#{n}@example.com" }
    password "password"
    sequence(:username) { |n| "member_#{n}" }

    trait :admin do
      admin true
    end
  end
end
