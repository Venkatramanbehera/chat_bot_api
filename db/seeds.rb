# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'faker'

Post.destroy_all

50.times do
  Post.create(
    title: Faker::Book.title,
    body: Faker::Lorem.paragraphs(number: 3).join("\n\n")
  )
  puts "Created"
end

puts "50 post created!"