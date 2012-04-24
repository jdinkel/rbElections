# == Schema Information
# Schema version: 20110429152829
#
# Table name: types
#
#  id         :integer         not null, primary key
#  value      :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

class Type < ActiveRecord::Base
  attr_accessible :value
  
  has_many :elections

  validates_uniqueness_of :value, :case_sensitive => false
end
