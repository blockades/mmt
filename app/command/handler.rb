module Command
  module Handler
    def with_aggregate(aggregate_class, aggregate_id)
      stream = "#{aggregate_class.name}$#{aggregate_id}"
      aggregate = aggregate_class.new(aggregate_id)
      aggregate = aggregate.load(stream)
      yield aggregate
      aggregate.store
    end
  end
end
