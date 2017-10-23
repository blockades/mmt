module CommandHandler
  class FinalisePortfolio
    include Command::Handler

    def call(command)
      with_aggregate(Domain::Portfolio, command.aggregate_id) do |portfolio|
        portfolio.finalise(command.member_id)
      end
    end
  end
end
