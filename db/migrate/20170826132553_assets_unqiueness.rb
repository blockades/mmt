class AssetsUnqiueness < ActiveRecord::Migration[5.0]
  def change
    add_index :assets, [:coin_id, :portfolio_id], unique: true

    # This is effectively a dup of the multiple column index
    # as the left most column can be scanned effectively though that
    # https://www.postgresql.org/docs/current/static/indexes-multicolumn.html
    remove_index :assets, :coin_id
  end
end
