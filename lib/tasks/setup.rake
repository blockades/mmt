# frozen_string_literal: true

namespace :setup do
  task coins: :environment do
    Coin.find_or_initialize_by(
      code: "NEO"
    ).update!(
      name: "AntShares",
    )

    Coin.find_or_initialize_by(
      code: "BTC"
    ).update!(
      name: "Bitcoin",
    )

    Coin.find_or_initialize_by(
      code: "ETH"
    ).update!(
      name: "Ethereum",
    )

    Coin.find_or_initialize_by(
      code: "GBP"
    ).update!(
      name: "Sterling",
      crypto_currency: false,
      subdivision: 2
    )

    Coin.find_or_initialize_by(
      code: "USD"
    ).update!(
      name: "United States Dollar",
      crypto_currency: false,
      subdivision: 2
    )
  end
end
