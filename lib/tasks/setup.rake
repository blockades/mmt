# frozen_string_literal: true

namespace :setup do
  task members: :environment do
    Member.find_or_initialize_by(email: "develop@blockades.dev") do |member|
      member.update!(admin: true, password: "password", username: 'develop')
    end

    Member.find_or_initialize_by(email: 'random@blockades.dev') do |member|
      member.update!(password: 'password', username: 'random')
    end
  end

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

  task all: [:members, :coins]
end

task setup: 'setup:all'
