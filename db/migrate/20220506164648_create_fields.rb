class CreateFields < ActiveRecord::Migration[7.0]
  def change
    create_table :fields do |t|
      t.integer :value
      t.integer :row
      t.integer :column
      t.references :board, null: false, foreign_key: true

      t.timestamps
    end
  end
end
