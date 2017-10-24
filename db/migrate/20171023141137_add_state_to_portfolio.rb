class AddStateToPortfolio < ActiveRecord::Migration[5.1]
  def change
    add_column :portfolios, :state, :string
    remove_index :portfolios, :member_id
    add_index :portfolios, :member_id, unique: true, where: "(next_portfolio_at is NULL) AND (state = 'finalised')"
  end
end
