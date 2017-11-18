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
      central_reserve_in_sub_units: 1_000_000_000
    )

    Coin.find_or_initialize_by(
      code: "BTC"
    ).update!(
      name: "Bitcoin",
      central_reserve_in_sub_units: 1_000_000_000
    )

    Coin.find_or_initialize_by(
      code: "ETH"
    ).update!(
      name: "Ethereum",
      central_reserve_in_sub_units: 1_000_000_000
    )

    Coin.find_or_initialize_by(
      code: "GBP"
    ).update!(
      name: "Sterling",
      central_reserve_in_sub_units: 1_000,
      crypto_currency: false,
      subdivision: 2
    )

    Coin.find_or_initialize_by(
      code: "USD"
    ).update!(
      name: "United States Dollar",
      central_reserve_in_sub_units: 1_000,
      crypto_currency: false,
      subdivision: 2
    )
  end

  task portfolios: :environment do
    member = Member.find_or_initialize_by(email: "develop@blockades.dev") do |member|
      member.update!(admin: true, password: "password", username: member.email.split('@').first.downcase)
    end

    unless member.live_portfolio.present?
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
  end

  task all: [:members, :coins, :portfolios]
end

task setup: 'setup:all'
