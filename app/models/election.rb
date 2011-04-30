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
  attr_accessor :data_file, :summary_file
  
  belongs_to :type
  belongs_to :status
  has_many :races, :dependent => :destroy

  validates_uniqueness_of :title, :case_sensitive => false

  #before_save :import_upload
  before_save :sleep_some

  private

    def sleep_some
      sleep 6
    end

    def import_upload
      #self.races += parse(data_file) if data_file

    end

    def parse(io_stream) # This MUST return an array of Line objects
      io_stream.read.split($/).map { |line_data| Line.new(:data => line_data) }
    end

end