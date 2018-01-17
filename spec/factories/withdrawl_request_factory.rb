FactoryBot.define do
  factory :withdrawl_request do
    association :member, factory: :member
    association :coin, factory: :bitcoin
    quantity { Utils.to_integer(1, coin.subdivision) }
    rate { coin.btc_rate }
  end
end
