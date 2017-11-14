# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def uuid_regex
    /\A[A-Za-z\d]([-\w]{,498}[A-Za-z\d])?\Z/i
  end
end
