# frozen_string_literal: true

module Annotations
  class Base < ApplicationRecord
    belongs_to :annotatable, polymorphic: true

    self.table_name = "annotations"

    TYPES = %w[Comment TransactionId].freeze

    TYPES.each do |type|
      define_method "#{type.underscore}?" do
        type == self.type
      end
    end

    scope :comments, -> { where(type: "Annotations::Comment") }
    scope :transaction_ids, -> { where(type: "Annotations::TransactionId") }

    scope :ordered, -> { order(created_at: :asc) }

    validates :body, presence: true

    validates :type, presence: true,
                     inclusion: { in: TYPES.map { |type| "Annotations::#{type}" } }
  end
end
