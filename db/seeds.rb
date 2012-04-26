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