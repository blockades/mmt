# frozen_string_literal: true

FactoryBot.define do
  factory :event, class: Events::Base do
    entry { 1000000000 }
    rate { 1 }

    trait :with_bitcoin do
      association :coin, factory: :bitcoin
      rate { coin.btc_rate }
    end

    trait :with_coin do
      association :coin, factory: :coin
      rate { coin.btc_rate }
    end

    trait :with_member do
      association :member, factory: :member
    end

    factory :asset_event, class: Events::Asset, traits: [:with_bitcoin]
    factory :liability_event, class: Events::Liability, traits: [:with_bitcoin, :with_member]
    factory :equity_event, class: Events::Equity, traits: [:with_bitcoin, :with_member]
  end
end
