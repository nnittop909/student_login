# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(email: "admin@admin.com", username: "admin", password: "1111111111", password_confirmation: "1111111111", role: "admin", first_name: "Admin", middle_name: "Admin", last_name: "Admin")
User.create!(email: "student@student.com", username: "student", password: "1111111111", password_confirmation: "1111111111", role: "student", first_name: "Student", middle_name: "Student", last_name: "Student")
YearLevel.create!(name: "I")
YearLevel.create!(name: "II")
YearLevel.create!(name: "III")
YearLevel.create!(name: "IV")
YearLevel.create!(name: "V")