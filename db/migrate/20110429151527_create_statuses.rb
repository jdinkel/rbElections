class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.string :value, :null => false

      t.timestamps
    end
    add_index :statuses, :value, :unique => true
  end

  def self.down
    drop_table :statuses
  end
end
