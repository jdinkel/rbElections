class CreatePrecinctsRaces < ActiveRecord::Migration
  def change
    create_table :precincts_races, :id => false do |t|
      t.references :precinct, :race
    end
  end
end