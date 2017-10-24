class CreatePortfolios < ActiveRecord::Migration[5.0]
  def change
    create_table :portfolios, id: :uuid do |t|
      t.references :member, type: :uuid, foreign_key: true, index: false, null: false
      t.uuid :next_portfolio_id
      t.datetime :next_portfolio_at

      t.timestamps
    end

    add_index :portfolios, :next_portfolio_id, unique: true
    add_foreign_key :portfolios, :portfolios, type: :uuid, column: :next_portfolio_id
    add_reference :assets, :portfolio, type: :uuid, index: true, foreign_key: true
    add_index :portfolios, :member_id, unique: true, where: "next_portfolio_at is NULL"
  end
end
