# frozen_string_literal: true

module Handlers
  class Base

    def with_aggregate(aggregate_class, aggregate_id = nil, aggregate_params = {})
      instance_stream = aggregate_id.nil? '' : "$#{aggregate_id}"
      stream = "#{aggregate_class.name}#{instance_stream}"
      aggregate_class.new(aggregate_params).tap do |aggregate|
        aggregate.load(stream)
        yield aggregate
        aggregate.store
      end
    end

  end
end
