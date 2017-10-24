# frozen_string_literal: true

module Workers
  class AssetAddedToPortfolio

    attr_reader :asset_attributes,
                :portfolio_attributes,
                :coin_attributes,
                :portfolio,
                :asset

    def call(event)
      event_asset_attributes(event)
      event_portfolio_attributes(event)
      event_coin_attributes(event)

      create_portfolio unless find_portfolio

      if find_asset
        asset.update(asset_attributes)
      else
        ::Asset.new(asset_attributes).tap(&:save)
      end
    end

    private

    def find_portfolio
      @portfolio = ::Portfolio.find_by(portfolio_attributes)
    end

    def create_portfolio
      @portfolio = ::Portfolio.new(portfolio_attributes.merge(state: :draft)).tap(&:save)
    end

    def find_asset
      @asset = ::Asset.find_by(asset_attributes.except(:quantity))
    end

    def find_coin
      ::Coin.find_by(coin_attributes)
    end

    def event_coin_attributes(event)
      @coin_attributes = { id: event.data.fetch(:coin_id) }
    end

    def event_asset_attributes(event)
      @asset_attributes = {
        coin_id: event.data.fetch(:coin_id),
        portfolio_id: event.data.fetch(:portfolio_id),
        quantity: event.data.fetch(:quantity),
      }
    end

    def event_portfolio_attributes(event)
      @portfolio_attributes = {
        id: event.data.fetch(:portfolio_id),
        member_id: event.data.fetch(:member_id)
      }
    end
  end
end
