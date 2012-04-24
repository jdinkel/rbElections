class CreateTypes < ActiveRecord::Migration
  def change
    create_table :types do |t|
      t.string :value, :null => false

      t.timestamps
    end
    add_index :types, :value, :unique => true
  end
end