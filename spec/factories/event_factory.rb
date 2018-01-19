# frozen_string_literal: true

FactoryBot.define do
  factory :asset_event, class: Events::Asset do
    association :coin, factory: :bitcoin
    assets { Utils.to_integer(10, coin.subdivision) }
  end

  factory :liability_event, class: Events::Liability do
    association :coin, factory: :bitcoin
    association :member, factory: :member
    liability { Utils.to_integer(10, coin.subdivision) }
  end

  factory :equity_event, class: Events::Equity do
    association :coin, factory: :bitcoin
    association :member, factory: :member
    equity { Utils.to_integer(10, coin.subdivision) }
  end
end
