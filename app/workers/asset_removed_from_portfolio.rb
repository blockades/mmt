# frozen_string_literal: true

module Workers
  class AssetRemovedFromPortfolio < ApplicationJob
    queue_as :default

    def perform(*args)
      call(YAML.load(args.first))
    end

    protected

    def call(event)
    end

  end
end
