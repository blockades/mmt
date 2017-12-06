# frozen_string_literal: true

FactoryBot.define do
  factory :coin do
    name Faker::Name.name
    code do
      YAML.load_file(Rails.root.join("spec", "support", "fixtures", "coins.yml")).find do |code|
        Coin.where(code: code).empty?
      end
    end
    subdivision 8
    crypto_currency true

    trait :gbp do
      name "Sterling"
      code "GBP"
      subdivision 2
      crypto_currency false
    end

    trait :btc do
      name "Bitcoin"
      code "BTC"
      subdivision 8
      crypto_currency true
    end

    factory :bitcoin, traits: [:btc]
    factory :sterling, traits: [:gbp]
  end
end
