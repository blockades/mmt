# frozen_string_literal: true

module ReadOnlyModel
  extend ActiveSupport::Concern

  included do
    def readonly?
      ENV["READONLY_TRANSACTIONS"] == "false" ? false : !new_record?
    end
  end
end
