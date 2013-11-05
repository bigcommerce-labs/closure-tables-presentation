# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'faker'

added = []
added << 0
1.upto 1000 do
  random_id = added.sample
  c = C2.create({
      :thread_key => 'test',
      :parent_id => random_id,
      :author => Faker::Name.name,
      :body => Faker::Lorem.sentences(2)
  })
  added << c.id
end