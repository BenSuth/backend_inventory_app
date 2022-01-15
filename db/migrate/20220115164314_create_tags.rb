class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags do |t|
      t.belongs_to :item, index: true
      t.text :names, array: true, default: []
      t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
