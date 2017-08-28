# frozen_string_literal: true

namespace :setup do
  task portfolios: :environment do
    user = User.find_or_initialize_by(email: "someone@example.com") do |usr|
      usr.update!(admin: true, password: "password")
    end

    btc = Coin.find_by(code: "BTC")
    eth = Coin.find_by(code: "ETH")
    Portfolio.create!(
      user: user,
      holdings_attributes: [
        { coin_id: btc.id, quantity: 1.2 },
        { coin_id: eth.id, quantity: 2.1 },
      ]
    )
  end

  task coins: :environment do
    Coin.find_or_create_by(
      name: "Bitcoin",
      code: "BTC",
      central_reserve_in_sub_units: 1_000_000_000
    )

    Coin.find_or_create_by(
      name: "Etherium",
      code: "ETH",
      central_reserve_in_sub_units: 1_000_000_000
    )

    Coin.find_or_create_by(
      name: "Sterling",
      code: "GBP",
      central_reserve_in_sub_units: 1_000,
      crypto_currency: false,
      subdivision: 2
    )
  end
end
