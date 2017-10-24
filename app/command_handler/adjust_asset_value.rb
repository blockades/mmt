module CommandHandler
  class AdjustAssetValue
    include Command::Handler

    def call
      with_aggregate(Domain::Portfolio, command.aggregate_id) do |portfolio|
        portfolio.update_asset(command.coin_id)
      end
    end
  end
end
