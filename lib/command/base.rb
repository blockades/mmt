# frozen_string_literal: true

module Command
  class Base
    include ActiveModel::Model
    include ActiveModel::Validations
    include ActiveModel::Conversion

    ValidationError = Class.new(StandardError)

    attr_reader :attributes

    def initialize(attributes = {})
      @attributes = attributes
      super
    end

    def validate!
      raise Command::ValidationError.new(errors.messages) unless valid?
    end

    def persisted?
      false
    end
  end
end
