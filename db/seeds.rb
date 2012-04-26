# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Status.create(:value => "Pending")
Status.create(:value => "Active")
Status.create(:value => "Final Results")
Type.create(:value => "Primary")
Type.create(:value => "General")
Type.create(:value => "Special")

Election.create(:date => "9 Apr 2011", :type_id => Type.find_by_value('General').id, :status_id => Status.find_by_value('Active').id, :party_split => false, :lock => false)
Election.create(:date => "3 Apr 2010", :type_id => Type.find_by_value('General').id, :status_id => Status.find_by_value('Final Results').id, :party_split => false, :lock => false)
Election.create(:date => "2 Apr 2009", :type_id => Type.find_by_value('Special').id, :status_id => Status.find_by_value('Final Results').id, :party_split => false, :lock => false)
Election.create(:date => "1 Apr 2011", :type_id => Type.find_by_value('Primary').id, :status_id => Status.find_by_value('Final Results').id, :party_split => false, :lock => false)