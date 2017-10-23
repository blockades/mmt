module Command
  class AddAssetToPortfolio < Command::Base
    attr_accessor :coin_id, :portfolio_id, :member_id

    validates :coin_id, :portfolio_id, :member_id, presence: true

    alias :aggregate_id :portfolio_id
  end
end
