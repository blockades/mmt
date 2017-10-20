module Command
  class AddAssetToPorfolio < Command::Base
    attr_accessor :coin_id, :portfolio_id

    validates :coin_id, :portfolio_id, presence: true

    alias :aggregate_id :portfolio_id
  end
end
