FactoryGirl.define do
  factory :coin do
    name Faker::Name.name
    code { Array.new(3){[*"A".."Z", *"0".."9"].sample}.join }
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
