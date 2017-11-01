# frozen_string_literal: true

FactoryBot.define do
  factory :portfolio do
    member
    trait :spent do
      association(:next_portfolio, factory: :portfolio)
    end

    trait :with_holdings do
      transient do
        holdings_count 1
      end

      after(:build, :stub) do |portfolio, evaluator|
        holdings = build_list(:holding, evaluator.holdings_count, portfolio: portfolio)
        portfolio.holdings = holdings
      end
    end
  end
end
