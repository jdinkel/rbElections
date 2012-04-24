# == Schema Information
# Schema version: 20110429152829
#
# Table name: candidates
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  party            :string(255)
#  race_id          :integer
#  cache_percentage :decimal(5, 2)
#  cache_votes      :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Candidate < ActiveRecord::Base
  attr_accessible :cache_percentage, :cache_votes, :name, :party
  
  belongs_to :race
  has_many :votes
  has_many :precincts, :through => :votes
  
  default_scope :order => 'candidates.cache_votes DESC'
end
