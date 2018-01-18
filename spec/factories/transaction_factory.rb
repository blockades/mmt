# frozen_string_literal: true

FactoryBot.define do
  factory :system_transaction do
     trait :system_deposit do
       association :source, factory: :admin
       association :destination, factory: :coin
       source_coin { destination }
       destination_coin { destination }
       destination_rate { destination_coin.btc_rate }
       destination_quantity { Utils.to_integer((1 / destination_coin.btc_rate), destination_coin.subdivision) }
     end

     trait :system_allocation do
       association :source, factory: :admin
       association :destination, factory: :member
       association :source_coin, factory: :bitcoin
       destination_coin { source_coin }
       destination_rate { destination_coin.btc_rate }
       destination_quantity { Utils.to_integer(1, destination_coin.subdivision) }
       association :initiated_by, factory: :admin
     end

    trait :system_withdrawl do
      association :source, factory: :bitcoin
      association :destination, factory: :admin
      source_coin { source }
      destination_coin { source }
      source_quantity { Utils.to_integer(1, source_coin.subdivision) }
    end

    trait :member_allocation do
      association :source, factory: :member
      association :destination, factory: :member
      association :source_coin, factory: :bitcoin
      destination_coin { source_coin }
      destination_quantity { Utils.to_integer(1, destination_coin.subdivision) }
      source_rate { source_coin.btc_rate }
    end

    trait :member_deposit do
      association :source, factory: :bitcoin
      association :destination, factory: :member
      source_coin { source }
      destination_coin { source }
      destination_quantity { Utils.to_integer(1, destination_coin.subdivision) }
    end

    trait :member_withdrawl do
      association :source, factory: :member
      association :destination, factory: :coin
      source_coin { destination }
      destination_coin { destination }
      source_quantity { Utils.to_integer(1, source_coin.subdivision) }
    end

    trait :member_exchange do
      association :source, factory: :member
      destination { source }
      association :source_coin, factory: :bitcoin
      association :destination_coin, factory: :sterling
      source_rate { source_coin.btc_rate }
      source_quantity { Utils.to_integer(1, source_coin.subdivision) }
      destination_rate { destination_coin.btc_rate }
      destination_quantity { Utils.to_integer((1 / destination_coin.btc_rate), destination_coin.subdivision) }
    end

    trait :initiated_by_source do
      initiated_by { source }
    end

    trait :initiated_by_destination do
      initiated_by { destination }
    end

    factory :member_exchange, class: Transactions::MemberExchange,
                              traits: [:member_exchange, :initiated_by_source]

    factory :member_withdrawl, class: Transactions::MemberWithdrawl,
                               traits: [:member_withdrawl, :initiated_by_source]

    factory :system_withdrawl, class: Transactions::SystemWithdrawl,
                               traits: [:system_withdrawl, :initiated_by_destination]

    factory :member_allocation, class: Transactions::MemberAllocation,
                                traits: [:member_allocation, :initiated_by_source]

    factory :system_allocation, class: Transactions::SystemAllocation,
                                traits: [:system_allocation]

    factory :member_deposit, class: Transactions::MemberDeposit,
                             traits: [:member_deposit, :initiated_by_destination]

    factory :system_deposit, class: Transactions::SystemDeposit,
                             traits: [:system_deposit, :initiated_by_source]
  end
end
