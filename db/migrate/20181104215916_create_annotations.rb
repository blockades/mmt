class CreateAnnotations < ActiveRecord::Migration[5.1]
  def change
    create_table :annotations, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.references :member, type: :uuid, foreign_key: true, null: false
      t.references :annotatable, type: :uuid, polymorphic: true, null: false
      t.string :type, null: false
      t.text :body

      t.timestamps
    end
  end
end
