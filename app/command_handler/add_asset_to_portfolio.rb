module CommandHandler
  class AddAssetToPortfolio
    include Command::Handler

    def call(command)
      with_aggregate(Domain::Portfolio, command.aggregate_id, portfolio_id: command.portfolio_id, member_id: command.member_id) do |portfolio|
        portfolio.add_asset(command.coin_id)
      end
    end
  end
end
