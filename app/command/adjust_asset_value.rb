module Command
  class AdjustAssetValue < Command::Base
    attr_accessor :asset_id, :portfolio_id

    validates :asset_id, :portfolio_id, presence: true

    alias :aggregate_id :asset_id
  end
end
