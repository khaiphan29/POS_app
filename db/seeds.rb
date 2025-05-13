# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Seeding admin user..."
User.find_or_create_by(email: 'admin@email.com') do |user|
  user.password = 'admin123'
  user.password_confirmation = 'admin123'
  user.admin!
end

puts "Seeding categories..."
[ DUMP_CATEGORY ].each do |cat_name|
  Category.find_or_create_by!(name: cat_name)
end

puts "Done!"
