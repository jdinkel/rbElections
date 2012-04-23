# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
Status.create(:id => 1, :value => "Pending")
Status.create(:id => 2, :value => "Active")
Status.create(:id => 3, :value => "Archived")
Type.create(:id => 1, :value => "Primary")
Type.create(:id => 2, :value => "General")
Type.create(:id => 3, :value => "Special")