# == Schema Information
# Schema version: 20110429152829
#
# Table name: races
#
#  id                        :integer         not null, primary key
#  name                      :string(255)
#  imported_as               :string(255)
#  instructions              :string(255)
#  election_id               :integer
#  cache_precincts_reporting :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#

class Race < ActiveRecord::Base
  attr_accessible :cache_precincts_reporting, :imported_as, :instructions, :name
  
  belongs_to :election

  has_many :candidates, :dependent => :destroy
  has_and_belongs_to_many :precincts

  def total_votes
    v = 0
    self.candidates.each do |c|
      v += c.cache_votes
    end
    v
  end
end
