# frozen_string_literal: true

Rails.application.configure do

  config.event_store = RailsEventStore::Client.new(
    event_broker: RailsEventStore::EventBroker.new(
      dispatcher: RailsEventStore::ActiveJobDispatcher.new(
        proxy_strategy: RailsEventStore::AsyncProxyStrategy::AfterCommit.new
      )
    )
  )

  config.event_store.tap do |event_store|
    # event_store.subscribe(Subscribers::ETC)
  end

end
