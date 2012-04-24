# == Schema Information
# Schema version: 20110429152829
#
# Table name: votes
#
#  id           :integer         not null, primary key
#  number       :integer
#  candidate_id :integer
#  precinct_id  :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Vote < ActiveRecord::Base
  attr_accessible :number
  
  belongs_to :candidate
  belongs_to :precinct
end
