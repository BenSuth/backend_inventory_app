class CreateExports < ActiveRecord::Migration[7.0]
  def change
    create_table :exports do |t|
      t.string :external_name
      t.string :internal_name
      t.string :path
      t.string :size
      t.string :file_type

      t.timestamps
    end
  end
end
