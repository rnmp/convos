# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'securerandom'

User.create(username: 'rnmp', email: 'rolando@bandd.co', password: 's3b45t14ng4y')

topic_names = ['random', 'ask', 'feedback', 'pics', 'videos', 'WTF', 'technology', 'science', 'design', 'politics', 'news', 'worldnews', 'sports', 'videogames', 'tv&film', 'books', 'music']
topic_names.length.times do |topic_name|
  Topic.create(:name => topic_names[topic_name])
end

# 1000.times do
#   Convo.create(
#     :title => "My Post #{SecureRandom.hex(2)}",
#     :comment => SecureRandom.hex(32),
#     :topic_id => rand(1..17)
#   )
# end
