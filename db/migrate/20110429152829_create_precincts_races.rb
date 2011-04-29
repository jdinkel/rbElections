class CreatePrecinctsRaces < ActiveRecord::Migration
  def self.up
    create_table :precincts_races, :id => false do |t|
      t.references :precinct, :race
    end
  end

  def self.down
    drop_table :precincts_races
  end
end
