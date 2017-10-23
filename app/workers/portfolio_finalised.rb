module Workers
  class PortfolioFinalised < ApplicationJob
    queue_as :default

    def perform(*args)
      call(YAML.load(args.first))
    end

    def call(event)
      portfolio = find_portfolio(event.data[:portfolio_id])
      # Build next portfolio
    end

    private

    def find_portfolio(id)
      ::Portfolio.find_by(id: id)
    end
  end
end
