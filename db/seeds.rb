# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create!(first_name: "Example",
						 last_name: "User",
						 email: "user@example.com",
						 password: "password",
						 password_confirmation: "password",
						 admin: true,
						 activated: true,
						 activated_at: Time.zone.now)

99.times do |n|
	first_name = Faker::Name.first_name
	last_name = Faker::Name.last_name
	email = "user-#{n+1}@example.com"
	password = "password"
	User.create!(first_name: first_name,
							 last_name: last_name,
							 email: email,
							 password: password,
							 password_confirmation: password,
							 activated: true,
							 activated_at: Time.zone.now)
end

users = User.order(:created_at).take(50)
sentence_lengths = (5..100).to_a
50.times do
	content = Faker::Lorem.sentence(sentence_lengths.sample)
	users.each { |user| user.points.create!(content: content) }
end

counterpoint_ids = (1..Point.all.count).to_a
users.each do |user|
	points = user.points
	points.each do |point|
		counterpoint_id = counterpoint_ids.sample
		unless point.nil?
			point.counterpoint_to_id =  counterpoint_id unless counterpoint_id % 5 == 0
			point.save if point.valid?
		end
	end
end

# Following relationships
users = User.all
user = users.first
following = users[2..50]
followers = users[3..41]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
