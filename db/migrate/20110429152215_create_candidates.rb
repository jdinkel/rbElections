class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :name
      t.string :party
      t.references :race
      t.decimal :cache_percentage, :precision => 5, :scale => 2
      t.integer :cache_votes

      t.timestamps
    end
  end
end