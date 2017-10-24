module Command
  class FinalisePortfolio < Command::Base
    attr_accessor :portfolio_id, :member_id

    validates :portfolio_id, :member_id, presence: true

    alias :aggregate_id :portfolio_id
  end
end
