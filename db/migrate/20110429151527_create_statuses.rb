class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :value, :null => false

      t.timestamps
    end
    add_index :statuses, :value, :unique => true
  end
end