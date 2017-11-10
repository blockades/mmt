# frozen_string_literal: true

Rails.application.configure do

  config.event_store.tap do |event_store|
    event_store.subscribe(Subscribers::Transaction::Load, [Events::Transaction::Load])
    event_store.subscribe(Subscribers::Transaction::Allocate, [Events::Transaction::Allocate])
    event_store.subscribe(Subscribers::Transaction::Exchange, [Events::Transaction::Exchange])
    event_store.subscribe(Subscribers::Transaction::Withdraw, [Events::Transaction::Withdraw])
  end

end
