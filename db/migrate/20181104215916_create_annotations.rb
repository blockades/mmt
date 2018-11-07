class CreateAnnotations < ActiveRecord::Migration[5.1]
  def change
    create_table :annotations, id: :uuid do |t|
      t.references :annotatable, type: :uuid, polymorphic: true, null: false
      t.string :type, null: false
      t.text :body

      t.timestamps
    end
  end
end
