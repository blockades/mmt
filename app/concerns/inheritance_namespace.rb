# frozen_string_literal: true

module InheritanceNamespace
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def find_sti_class(_type_name)
      _type_name = self.name
      super
    end

    def sti_name
      self.name.demodulize
    end
  end
end
