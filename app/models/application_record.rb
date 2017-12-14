# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def error_message
    errors.full_messages.to_sentence
  end
end
