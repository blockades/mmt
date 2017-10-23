# frozen_string_literal: true

FactoryGirl.define do
  factory :portfolio do
    member
    trait :spent do
      association(:next_portfolio, factory: :portfolio)
    end

    trait :with_assets do
      transient do
        assets_count 1
      end

      after(:build, :stub) do |portfolio, evaluator|
        assets = build_list(:asset, evaluator.assets_count, portfolio: portfolio)
        portfolio.assets = assets
      end
    end
  end
end
