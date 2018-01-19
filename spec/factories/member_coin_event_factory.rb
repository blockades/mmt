# frozen_string_literal: true

FactoryBot.define do
  factory :member_coin_event do
    association :coin, factory: :bitcoin
    association :member, factory: :member
    liability { Utils.to_integer(10, coin.subdivision) }
  end
end
