class CreatePrecincts < ActiveRecord::Migration
  def self.up
    create_table :precincts do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :precincts
  end
end
