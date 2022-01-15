class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.text :description
      t.integer :count, null: false
      t.text :tags, array: true, default: []

      t.timestamps
      t.datetime :deleted_at, precision: 6
    end
  end
end
