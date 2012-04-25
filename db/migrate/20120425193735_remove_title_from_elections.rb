class RemoveTitleFromElections < ActiveRecord::Migration
  def change
    remove_column :elections, :title
    add_index :elections, :date, :unique => true
  end
end
