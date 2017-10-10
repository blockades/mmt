# frozen_string_literal: true

namespace :setup do
  task portfolios: :environment do
    member = Member.find_or_initialize_by(email: "someone@example.com") do |usr|
      usr.update!(admin: true, password: "password")
    end

    btc = Coin.find_by(code: "BTC")
    eth = Coin.find_by(code: "ETH")
    Portfolio.create!(
      member: member,
      holdings_attributes: [
        { coin_id: btc.id, quantity: 1.2 },
        { coin_id: eth.id, quantity: 2.1 },
      ]
    )
  end

  task coins: :environment do
    Coin.find_or_initialize_by(
      name: "Bitcoin",
      code: "BTC"
    ).update!(
      central_reserve_in_sub_units: 1_000_000_000
    )

    Coin.find_or_initialize_by(
      name: "Ethereum",
      code: "ETH"
    ).update!(
      central_reserve_in_sub_units: 1_000_000_000
    )

    Coin.find_or_initialize_by(
      name: "Sterling",
      code: "GBP"
    ).update!(
      central_reserve_in_sub_units: 1_000,
      crypto_currency: false,
      subdivision: 2
    )
  end
end
