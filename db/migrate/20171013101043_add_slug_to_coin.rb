# frozen_string_literal: true

class AddSlugToCoin < ActiveRecord::Migration[5.0]
  def change
    add_column :coins, :slug, :string
  end
end
