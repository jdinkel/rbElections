class RemoveTitleFromElections < ActiveRecord::Migration
  def up
    remove_column :elections, :title
    add_index :elections, :date, :unique => true
  end

  def down
    add_column :elections, :title, :string
    Election.all.each do |e|
      e.title = "#{e.type} Election On #{e.date}"
      e.save!
    end
    change_column :elections, :title, :string, :null => false
    remove_index :elections, :date
    add_index :elections, :title, :unique => true
  end
end
