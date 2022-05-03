class CreateFields < ActiveRecord::Migration[7.0]
  def change
    create_table :fields do |t|
      t.references :board, null: false, foreign_key: true

      t.timestamps
    end
  end
end
