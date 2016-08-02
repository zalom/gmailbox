# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
users = {
  user1: { email: 'zlatko@example.com', password: '123456' },
  user2: { email: 'ramo@example.com', password: '123456' },
  user3: { email: 'semso@example.com', password: '123456' }
}

users.each do |_k, v|
  User.create!(
    email: v[:email],
    password: v[:password],
    password_confirmation: v[:password],
    confirmed_at: DateTime.now
  )
end

user1 = User.find_by_email(users[:user1][:email])
user2 = User.find_by_email(users[:user2][:email])
user3 = User.find_by_email(users[:user3][:email])

user1.sent_messages.create(
  subject: 'First email ever',
  content: 'First seeded email',
  recipient_id: User.find_by_email('semso@example.com').id, 
  sent_at: Time.now
)

user2.sent_messages.create(
  subject: 'Second email',
  content: 'Second seeded email',
  recipient_id: User.find_by_email('semso@example.com').id, 
  sent_at: Time.now
)
