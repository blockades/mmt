module Domain
  class Asset

    def initialize(portfolio_id, coin_id)
      @coin_id = coin_id
      @portfolio_id = portfolio_id
    end

    def adjust_value

    end

    attr_reader :coin_id, :portfolio_id
  end
end
