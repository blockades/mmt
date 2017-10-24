module CommandHandler
  class FinalisePortfolio
    include Command::Handler

    def call(command)
      with_aggregate(Domain::Portfolio, command.aggregate_id, attributes(command)) do |portfolio|
        portfolio.finalise!
      end
    end

    def attributes(command)
      { portfolio_id: command.portfolio_id, member_id: command.member_id }
    end
  end
end
