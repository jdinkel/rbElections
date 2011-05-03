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

  default_scope :order => 'elections.date DESC'

  #before_save :import_upload
  #after_save :sleep_some
  ## need to consider delayed_job when setting status.  I wouldn't want the
  ## status updated before the numbers are updated.  Alternatively, I could
  ## code the interface so only the election metadata is changed, or only
  ## files are uploaded (split to separate interfaces).
  after_create :process_uploads  # delayed_job can not process before creation
  before_update :process_uploads  # process first, so status does not change before data

  private

    def process_uploads
      self.delay.process_details_and_summary(details_file, summary_file)
    end
    
    def process_details_and_summary(details_stream, summary_stream)
      election_data = import_data(details_stream, summary_stream)
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
      raw_details = details_stream.read.split($/).map do |line_data|

      end
    end

    ### After this is really just for reference

    def parse(io_stream) # This MUST return an array of Line objects
      io_stream.read.split($/).map { |line_data| Line.new(:data => line_data) }
    end

    def import_data(detail_file='10PKSBUTLD.txt', summary_file='10PKSBUTLS.txt')

      #datafile_directory = '/home/james/rails_projects/rbElections/app/temp_test/datafiles/'
      #detail_file = datafile_directory + detail_file
      #summary_file = datafile_directory + summary_file

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

      # read the detail file into an array
      detail_file_lines = File.readlines detail_file

      election_details = detail_file_lines.map do |line|
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

          #return a hash of these values, after checking the line is legit (not one of the junk lines from the top of the file)
        end
      end

      # read the summary file into an array
      summary_file_lines = File.readlines summary_file

      election_summary = summary_file_lines.map do |line|
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
      return election_summary.compact, election_details.compact
    end

    def parse_data(raw_summary, raw_details)

      election = Election.first #obviously, I need to keep track of the current working election in the production app

      #something = 'race name from details'
      #Race.where(:conditions => {:name => something, :election => election}).exists?
      #Race.find_or_initialize_by_name_and_election(something, election) # does not work
      #race = Race.find_or_initialize_by_imported_as_and_election_id(something, election.id) # works, remember I'm allowing the name to be changed

      Election.transaction do
        raw_details.each do |record|

          # This step takes longer than reading the files, and longer than
          # parsing the summary file.  This step takes about 20 seconds, the
          # other two steps take about 2 seconds each.  So this is the part
          # to optimize.
          # memcached may help with this, or at least free me to optimize the
          # algorithm without worrying about database queries.
          # It seems about 12 seconds of this is spent with the save!s.  That
          # does leave 8 seconds to ruby parsing, but 12 seconds of room for
          # a faster database.

          race = Race.find_or_initialize_by_imported_as_and_election_id(record[:race_name], election.id)
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
          race.vote_for = "#{record[:allowed]} of #{race.candidates.count}"

          # save everything
          race.save!
          candidate.save!
          precinct.save!
          #add the precinct to the race, if not already
          precinct.races << race unless precinct.races.include?(race) #this saves immediately
          vote.save!

        end

        raw_summary.each do |record|

          # get the cache_precincts_reporting for each race
          race = Race.find_by_name(record[:race_name])
          race.cache_precincts_reporting = "#{record[:counted_precincts]} of #{record[:eligible_precincts]}"

          # fill the cache_total_votes for each candidate
          candidate = Candidate.find_by_name_and_race_id(record[:candidate_name], race.id)
          candidate.cache_votes = record[:candidate_total_votes]

          race.save!
          candidate.save!
        end
      end
    end

    def cache_candidate_percent_votes
      election = Election.first

      election.races.each do |race|
        race.candidates.each do |candidate|
          if candidate.cache_votes == 0
            candidate.cache_percentage = 0
          else
            candidate.cache_percentage = (candidate.cache_votes.to_f / candidate.race.total_votes) * 100
          end
          candidate.save
        end
      end
    end

end