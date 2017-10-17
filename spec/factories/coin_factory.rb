# frozen_string_literal: true

FactoryGirl.define do
  factory :coin do
    name Faker::Name.name
    code do
      YAML.load_file(Rails.root.join 'spec','support','fixtures','coins.yml').find do |code|
        Coin.where(code: code).empty?
      end
    end
    subdivision 8
    central_reserve_in_sub_units 1_000_000
    crypto_currency true

    trait :gbp do
      subdivision 8
      central_reserve_in_sub_units 1_000_000
      crypto_currency true
    end
  end
end
