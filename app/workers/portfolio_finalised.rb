module Workers
  class PortfolioFinalised < ApplicationJob
    queue_as :default

    def perform(*args)
      call(YAML.load(args.first))
    end

    protected

    def call
    end
  end
end
