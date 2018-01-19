# frozen_string_literal: true

FactoryBot.define do
  factory :coin_event do
    association :coin, factory: :bitcoin
    assets { Utils.to_integer(10, coin.subdivision) }
  end
end
