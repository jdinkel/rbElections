class CreateElections < ActiveRecord::Migration
  def change
    create_table :elections do |t|
      t.string :title, :null => false
      t.date :date, :null => false
      t.references :type, :status, :null => false
      t.boolean :party_split, :null => false, :default => false
      t.boolean :lock, :null => false, :default => false

      t.timestamps
    end
    add_index :elections, :title, :unique => true
  end
end
