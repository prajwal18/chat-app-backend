# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Otp.destroy_all
Message.destroy_all
User.destroy_all

User.create(name: 'Unish Thakuri Shahi', email: 'eunessshahithakuri@gmail.com', password: 'MyPassword')
User.create(name: 'Prajwal Gautam', email: 'prajwalgautam10@gmail.com', password: 'password')


sender = User.where(email: 'prajwal@gmail.com').first
receiver = User.where(email: 'unesh@gmail.com').first

Message.create(sender: sender, receiver: receiver, message: 'Hello, how are you doing?')

# Creating otp for new users
# Otp.create(otp:"123456", user_id: sender.id)
