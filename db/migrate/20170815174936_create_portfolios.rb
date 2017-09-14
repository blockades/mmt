class CreatePortfolios < ActiveRecord::Migration[5.0]
  def change
    create_table :portfolios do |t|
      t.references :user, foreign_key: true, index: false, null: false
      t.integer :next_portfolio_id
      t.datetime :next_portfolio_at

      t.timestamps
    end

    add_index :portfolios, :next_portfolio_id, unique: true
    add_foreign_key :portfolios, :portfolios, column: :next_portfolio_id
    add_reference :holdings, :portfolio, index: true, foreign_key: true
    add_index :portfolios, :user_id, unique: true, where: "next_portfolio_at is NULL"
  end
end
