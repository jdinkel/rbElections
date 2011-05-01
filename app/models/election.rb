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
  #after_save :sleep_some
  ## need to consider delayed_job when setting status.  I wouldn't want the
  ## status updated before the numbers are updated.  Alternatively, I could
  ## code the interface so only the election metadata is changed, or only
  ## files are uploaded (split to separate interfaces).
  after_create :do_something  # delayed_job can not processs before creation
  before_update :do_something

  private

    def do_something
      #self.delay.something
    end

    def sleep_some
      self.delay.go_to_sleep(15)  # this works
    end

    def go_to_sleep(how_long)
      sleep how_long
    end

    def import_upload
      # self.races += parse(data_file) if data_file # is this an immediate save?
      # self.races += self.delay.parse(data_file)

    end

    def parse(io_stream) # This MUST return an array of Line objects
      io_stream.read.split($/).map { |line_data| Line.new(:data => line_data) }
    end

end