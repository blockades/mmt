class Plan < ApplicationRecord

  def high?
    name == 'high'
  end

  def medium?
    name == 'medium'
  end

  def low?
    name == 'low'
  end
end
