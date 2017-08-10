class PopulateDefaultPlans < ActiveRecord::Migration[5.0]
  def self.up
    plans.each do |plan|
      Plan.create(name: plan)
    end
  end

  def self.down
    Plan.where(name: plans).destroy_all
  end

  private

  def plans
    [ 'High', 'Medium', 'Low' ]
  end
end
