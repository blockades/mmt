# frozen_string_literal: true

Rails.application.configure do
  config.generators do |g|
    g.orm :active_record, primary_key_type: :uuid
  end
end
