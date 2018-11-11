# frozen_string_literal: true

module Utils
  class << self
    def precision(subdivision)
      10**subdivision
    end

    def to_decimal(quantity, subdivision)
      quantity.to_d / precision(subdivision)
    end

    def to_integer(quantity, subdivision)
      (quantity * precision(subdivision)).round
    end
  end
end
