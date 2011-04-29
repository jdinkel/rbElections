class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :number
      t.references :candidate, :precinct

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
