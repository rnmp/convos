# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'securerandom'

User.create(username: 'rnmp', email: 'rolando@bandd.co', password: 's3b45t14ng4y', is_admin: true)

topic_names = ['random', 'feedback', 'politics & news', 'culture', 'lifestyle', 'fashion & style', 'science & tech', 'sports', 'international']
topic_names.length.times do |topic_name|
  Topic.create(:name => topic_names[topic_name])
end
