class CreateTypes < ActiveRecord::Migration
  def self.up
    create_table :types do |t|
      t.string :value, :null => false

      t.timestamps
    end
    add_index :types, :value, :unique => true
  end

  def self.down
    drop_table :types
  end
end
