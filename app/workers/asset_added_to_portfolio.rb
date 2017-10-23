# frozen_string_literal: true

module Workers
  class AssetAddedToPortfolio < ApplicationJob
    queue_as :default

    def perform(*args)
      call(YAML.load(args.first))
    end

    def call(event)
      create_draft_portfolio(portfolio_params(event))
      asset = find_asset(asset_params(event)) ||
              create_asset(asset_params(event))
      # Here we want to adjust the assets value and save it
    end

    private

    def create_draft_portfolio(id:, member_id:)
      return if ::Portfolio.where(id: id).exists?
      ::Portfolio.create!(
        id: id,
        member_id: member_id,
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

    def portfolio_params(event)
      { id: event.data[:portfolio_id], member_id: event.data[:member_id] }
    end
  end
end
