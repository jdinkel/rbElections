class CreateRaces < ActiveRecord::Migration
  def self.up
    create_table :races do |t|
      t.string :name
      t.string :imported_as
      t.string :instructions
      t.references :election
      t.string :cache_precincts_reporting

      t.timestamps
    end
  end

  def self.down
    drop_table :races
  end
end
