# frozen_string_literal: true

module Workers
  class AssetAddedToPortfolio

    attr_reader :asset_params, :portfolio_params, :portfolio, :asset

    def call(event)
      event_asset_attributes(event)
      event_portfolio_attributes(event)

      create_portfolio unless find_portfolio
      if find_asset
        asset.update(asset_params)
      else
        create_asset
      end
    end

    private

    def find_portfolio
      @portfolio = ::Portfolio.find_by(portfolio_params)
    end

    def create_portfolio
      @portfolio = ::Portfolio.new(portfolio_params.merge(state: :draft)).tap(&:save)
    end

    def find_asset
      @asset = ::Asset.find_by(asset_params.except(:quantity))
    end

    def create_asset
      @asset = ::Asset.new(asset_params).tap(&:save)
    end

    def event_asset_attributes(event)
      @asset_params = { coin_id: event.data.fetch(:coin_id), portfolio_id: event.data.fetch(:portfolio_id), quantity: event.data.fetch(:quantity) }
    end

    def event_portfolio_attributes(event)
      @portfolio_params = { id: event.data.fetch(:portfolio_id), member_id: event.data.fetch(:member_id) }
    end
  end
end
