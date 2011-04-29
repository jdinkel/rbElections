# == Schema Information
# Schema version: 20110429152829
#
# Table name: precincts
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Precinct < ActiveRecord::Base
  has_and_belongs_to_many :races
  has_many :votes
  has_many :candidates, :through => :votes
end
