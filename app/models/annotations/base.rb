# frozen_string_literal: true

module Annotations
  class Base < ApplicationRecord
    belongs_to :annotatable, polymorphic: true

    self.table_name = "annotations"
    self.store_full_sti_class = false

    TYPES = %w[Comment TransactionId].freeze

    validates :type, presence: true, inclusion: { in: TYPES }
    validates :body, presence: true
  end
end
