# == Schema Information
# Schema version: 20110429152829
#
# Table name: elections
#
#  id          :integer         not null, primary key
#  title       :string(255)     not null
#  date        :date            not null
#  type_id     :integer         not null
#  status_id   :integer         not null
#  party_split :boolean         not null
#  lock        :boolean         not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Election < ActiveRecord::Base
  belongs_to :type
  belongs_to :status
  has_many :races, :dependent => :destroy

  validates_uniqueness_of :title, :case_sensitive => false
end
