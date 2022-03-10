# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# Create a main sample user.
# User.create!(name: "Example User",
#     email: "example@railstutorial.org",
#     password: "foobar",
#     password_confirmation: "foobar",
#     admin: true)

20.times do |n|
  content = "Micropost #{n+1}"
  user_id = User.first.id
  Micropost.create!(content: content, user_id: user_id)
end
