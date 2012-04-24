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
  attr_accessor :details_upload, :summary_upload
  attr_accessible :details_upload, :summary_upload, :title, :date, :type_id, :status_id, :lock, :party_split
  
  belongs_to :type
  belongs_to :status
  has_many :races, :dependent => :destroy

  validates :title, :presence => true, :uniqueness => { :case_sensitive => false }
  validates :type_id, :presence => true,
            :inclusion => { :in => Type.all.map { |t| t.id },
              :message => "%{value} is not a valid type id" }
  validates :status_id, :presence => true,
            :inclusion => { :in => Status.all.map { |t| t.id },
              :message => "%{value} is not a valid status id" }
  validates :details_upload, :presence => {
              :message => "can't be blank when uploading Summary" },
              :unless => "summary_upload.nil?"
  validates :summary_upload, :presence => {
              :message => "can't be blank when uploading Details" },
              :unless => "details_upload.nil?"
  # I should put in some filename checks, to be sure the names are the same
  # except the details file ends in (D|d) and the summary file ends in (S|s).
  # in the parse operation I may then do some more detailed checks to ensure
  # the details does look like a details file and the summary file does look
  # like a summary file before performing the parse and save.

  default_scope :order => 'elections.date DESC'

  ## need to consider delayed_job when setting status.  I wouldn't want the
  ## status updated before the numbers are updated.  Alternatively, I could
  ## code the interface so only the election metadata is changed, or only
  ## files are uploaded (split to separate interfaces).
  after_create :process_details_and_summary
  # I have to use after_create because before_create or before_save can not
  # save the date before the record is saved.  I would like to figure out a
  # better way to do this.
  before_update :process_details_and_summary



    #def process_uploads
    #  #self.delay.process_details_and_summary(details_file, summary_file)
    #  self.process_details_and_summary(details_upload.read.split($/), summary_upload.read.split($/))
    #end
    
    #def process_details_and_summary(details, summary)
    #  raw_data = import_data(details, summary)
    #  save_data(raw_data)
    #end
    def process_details_and_summary
      unless details_upload.nil? || summary_upload.nil?
        save_data import_data(details_upload.read.split($/), summary_upload.read.split($/))
      end
    end

    def import_data(details,summary)
            # Character range variables for fixed-width columns in text files

      detail_total_vote_char_range = 11..16
      detail_party_char_range = 47..49
      detail_race_name_char_range = 57..112
      detail_candidate_name_char_range = 113..150
      detail_precinct_name_char_range = 151..180
      detail_allowed_char_range = 206..207 # ah! I bet this is how many choices are allowed (pick # of #)

      summary_eligible_precincts_char_range = 7..10
      summary_candidate_total_votes_char_range = 11..17
      summary_counted_precincts_char_range = 53..56
      summary_race_name_char_range = 74..129
      summary_candidate_name_char_range = 130..167

      # Process details
      raw_details = details.map do |line|
        #return a hash of these values, after checking the line is legit (not one of the junk lines from the top of the file)
        if line[detail_allowed_char_range].to_i > 0
          {
            :total_vote        => line[detail_total_vote_char_range],
            :party             => line[detail_party_char_range],
            :race_name         => line[detail_race_name_char_range].rstrip,
            :candidate_name    => line[detail_candidate_name_char_range].rstrip,
            :precinct_name     => line[detail_precinct_name_char_range].rstrip,
            :allowed           => line[detail_allowed_char_range].to_i,
          }
        end
      end

      # Process summary
      raw_summary = summary.map do |line|
        if line[193..194].to_i > 0
          {
            :candidate_total_votes  => line[summary_candidate_total_votes_char_range].to_i,
            :eligible_precincts     => line[summary_eligible_precincts_char_range].to_i,
            :counted_precincts      => line[summary_counted_precincts_char_range].to_i,
            :race_name              => line[summary_race_name_char_range].rstrip,
            :candidate_name         => line[summary_candidate_name_char_range].rstrip
          }
        end
      end
      return { :raw_details => raw_details.compact, :raw_summary => raw_summary.compact }
    end

    def save_data(data_hash)
      Election.transaction do
        data_hash[:raw_details].each do |record|

          # This step takes longer than reading the files, and longer than
          # parsing the summary file.  This step takes about 20 seconds, the
          # other two steps take about 2 seconds each.  So this is the part
          # to optimize.
          # memcached may help with this, or at least free me to optimize the
          # algorithm without worrying about database queries.
          # It seems about 12 seconds of this is spent with the save!s.  That
          # does leave 8 seconds to ruby parsing, but 12 seconds of room for
          # a faster database.

          race = Race.find_or_initialize_by_imported_as_and_election_id(record[:race_name], self.id)
          race.name = record[:race_name] unless race.name

          candidate = Candidate.find_or_initialize_by_name_and_race_id(record[:candidate_name], race.id)
          candidate.party = record[:party]
          candidate.race = race

          precinct = Precinct.find_or_initialize_by_name(record[:precinct_name])

          #add the precinct to the race, if not already
          #precinct.races << race unless precinct.races.include?(race)

          #add or update vote number to the precint-candidate relation
          vote = Vote.find_or_initialize_by_candidate_id_and_precinct_id(candidate.id, precinct.id)
          vote.precinct = precinct
          vote.candidate = candidate
          vote.number = record[:total_vote]

          # do this after adding the candidate
          race.instructions = "#{record[:allowed]} of #{race.candidates.count}"

          # save everything
          race.save!
          candidate.save!
          precinct.save!
          #add the precinct to the race, if not already
          precinct.races << race unless precinct.races.include?(race) #this saves immediately
          vote.save!
        end

        data_hash[:raw_summary].each do |record|
          # get the cache_precincts_reporting for each race
          race = Race.find_by_name(record[:race_name])
          race.cache_precincts_reporting = "#{record[:counted_precincts]} of #{record[:eligible_precincts]}"

          # fill the cache_total_votes for each candidate
          candidate = Candidate.find_by_name_and_race_id(record[:candidate_name], race.id)
          candidate.cache_votes = record[:candidate_total_votes]

          race.save!
          candidate.save!
        end

        # Calculate and store the candidates' vote percentages
=begin
        self.races.each do |race|
          race.candidates.each do |candidate|
            if candidate.cache_votes == 0
              candidate.cache_percentage = 0
            else
              candidate.cache_percentage = (candidate.cache_votes.to_f / candidate.race.total_votes) * 100
            end
            candidate.save!
          end
        end
=end
      end
    end

end