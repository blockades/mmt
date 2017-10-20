module Domain
  class Portfolio
    include AggregateRoot

    AlreadySubmitted = Class.new(StandardError)
    PorfolioExpired = Class.new(StandardError)
    MissingMember = Class.new(StandardError)

    def initialize(id)
      @id = id
      @state = :draft
      @assets = []
    end

    def finalise(portfolio_number, member_id)
      raise AlreadySubmitted if state == :finalised
      raise PorfolioExpired if state == :expired
      raise MissingMember unless member_id
      apply Events::PorfolioFinalised.new(data: { porfolio_id: id, portfolio_number: portfolio_number, member_id: member_id })
    end

    def add_asset(coin_id)
      raise AlreadySubmitted if state == :finalised
      apply Events::AddAssetToPortfolio.new(data: { portfolio_id: id, coin_id: coin_id })
    end

    def remove_asset(coin_id)
      raise AlreadySubmitted if state == :finalised
      apply Events::RemoveAssetFromPortfolio.new(data: { portfolio_id: id, coin_id: coin_id })
    end

    attr_reader :id
    private
    attr_accessor :state, :member_id, :number, :assets

    def apply_portfolio_finalised(event)
      @member_id = event.data[:member_id]
      @number = event.data[:portfolio_number]
      @state = :finalised
    end

    def apply_add_asset_to_portfolio(event)
      coin_id = event.data[:coin_id]
      asset = find_asset(coin_id)
      if asset.any?
        Command::UpdateAssetValue.new(asset_id)
      else
        @assets << create_asset(id, coin_id)
      end
    end

    def apply_remove_asset_from_portfolio(event)
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
