class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :number
      t.references :candidate, :precinct

      t.timestamps
    end
  end
end