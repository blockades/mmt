# frozen_string_literal: true

class AddSlugToMember < ActiveRecord::Migration[5.0]
  def change
    add_column :members, :slug, :string
  end
end
