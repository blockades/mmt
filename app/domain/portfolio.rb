module Domain
  class Portfolio
    include AggregateRoot

    AlreadySubmitted = Class.new(StandardError)
    PorfolioExpired = Class.new(StandardError)
    MissingMember = Class.new(StandardError)

    attr_reader :id, :member_id

    def initialize(portfolio_id:, member_id:)
      @id = portfolio_id
      @member_id = member_id
      @state = :draft
      @assets = []
    end

    def finalise(member_id)
      raise AlreadySubmitted if state == :finalised
      raise PorfolioExpired if state == :expired
      raise MissingMember unless member_id
      apply Events::PortfolioFinalised.new(data: { porfolio_id: id, member_id: member_id })
    end

    def add_asset(coin_id)
      raise AlreadySubmitted if state == :finalised
      apply Events::AssetAddedToPortfolio.new(data: { portfolio_id: id, coin_id: coin_id, member_id: member_id })
    end

    def remove_asset(coin_id)
      raise AlreadySubmitted if state == :finalised
      apply Events::AssetRemovedFromPortfolio.new(data: { portfolio_id: id, coin_id: coin_id })
    end

    private

    attr_accessor :state, :member_id, :assets

    def apply_portfolio_finalised(event)
      @state = :finalised
    end

    def apply_asset_added_to_portfolio(event)
      coin_id = event.data[:coin_id]
      asset = find_asset(coin_id)
      return unless asset.any?
      @assets << create_asset(id, coin_id)
    end

    def apply_asset_removed_from_portfolio(event)
      coin_id = event.data[:coin_id]
      asset = find_asset(coin_id)
      return unless asset.any?
      remove_asset(asset)
    end

    def find_asset(coin_id)
      @assets.select { |asset| asset.coin_id == coin_id }
    end

    def create_asset(portfolio_id, coin_id)
      Domain::Asset.new(portfolio_id, coin_id)
    end

    def remove_asset(asset)
      @assets.delete(asset)
    end

  end
end
