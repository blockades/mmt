class AddStateToPortfolio < ActiveRecord::Migration[5.1]
  def change
    add_column :portfolios, :state, :string
  end
end
