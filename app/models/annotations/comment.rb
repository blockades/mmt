# frozen_string_literal: true

module Annotations
  class Comment < Annotations::Base
    belongs_to :member

  end
end
