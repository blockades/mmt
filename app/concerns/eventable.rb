# frozen_string_literal: true

module Eventable
  extend ActiveSupport::Concern

  included do
    def readonly?
      (ENV["READONLY_TRANSACTIONS"] == "false") ? false : !new_record?
    end

    scope :forward, -> { order(created_at: :asc) }
    scope :backward, -> { order(created_at: :desc) }
    scope :forward_from, ->(event) { forward.where('created_at >= ?', event.created_at) }
    scope :backward_from, ->(event) { backward.where('created_at <= ?', event.created_at) }
  end
end
