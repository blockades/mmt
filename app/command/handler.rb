module Command
  module Handler
    def with_aggregate(aggregate_class, aggregate_id, aggregate_params = {})
      stream = "#{aggregate_class.name}$#{aggregate_id}"
      aggregate = aggregate_class.new(aggregate_params).load(stream)
      yield aggregate
      aggregate.store
    end
  end
end
