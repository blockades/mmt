module Command
  class AddAssetToPortfolio < Command::Base
    attr_accessor :coin_id, :portfolio_id, :member_id, :quantity

    validates :coin_id, :portfolio_id, :member_id, :quantity, presence: true

    alias :aggregate_id :portfolio_id
  end
end
