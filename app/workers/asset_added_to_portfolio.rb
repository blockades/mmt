# frozen_string_literal: true

module Workers
  class AssetAddedToPortfolio < ApplicationJob
    queue_as :default

    def perform(*args)
      # Calls the first argument passed by the subscriber
      call(YAML.load(args.first))
    end

    private

    def call(event)
      create_draft_portfolio(event.data[:portfolio_id])
      asset = find_asset(asset_params(event)) ||
              create_asset(asset_params(event))
      # Here we want to adjust the assets value and save it
    end

    def create_draft_portfolio(uid)
      return if ::Portfolio.where(uid: uid).exists?
      ::Portfolio.create!(
        uid: uid,
        state: :draft,
      )
    end

    def find_asset(coin_id:, portfolio_id:)
      ::Asset.where(coin_id: coin_id, portfolio_id: portfolio_id).first
    end

    def create_asset(coin_id:, portfolio_id:)
      ::Asset.new.tap do |asset|
        asset.coin_id = coin_id
        asset.portfolio_id = portfolio_id
        asset.save!
      end
    end

    def asset_params(event)
      { coin_id: event.data[:coin_id], portfolio_id: event.data[:portfolio_id] }
    end
  end
end
