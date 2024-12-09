# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#User.create!(email: 'admin@example.com', password: 'password', admin: true)
user = User.new(
  email: 'admin',         # Invalid email format
  password: 'admin',      # Invalid password length
  password_confirmation: 'admin',  # Password confirmation
  admin: true             # Set the user as an admin
)

# Save without validation
user.save(validate: false)