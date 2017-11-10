# frozen_string_literal: true

Rails.application.configure do

  config.event_store.tap do |event_store|
    # event_store.subscribe(Subscribers::ETC)
  end

end
