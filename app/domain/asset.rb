module Domain
  class Asset

    def initialize(portfolio_id:, coin_id:, quantity:)
      @coin_id = coin_id
      @portfolio_id = portfolio_id
      @quantity = quantity
    end

    def adjust_value

    end

    attr_reader :coin_id, :portfolio_id
  end
end
