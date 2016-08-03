users = {
  user1: { email: 'zlatko@example.com', password: '123456' },
  user2: { email: 'mirza@example.com', password: '123456' },
  user3: { email: 'ervin@example.com', password: '123456' },
  user4: { email: 'sedad@example.com', password: '123456' },
  user5: { email: 'enes@example.com', password: '123456' },
  user6: { email: 'jasmin@example.com', password: '123456' }
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
  recipient_id: User.find_by_email(users[:user3][:email]).id,
  sent_at: Time.now
)

user2.sent_messages.create(
  subject: 'Second email',
  content: 'Second seeded email',
  recipient_id: User.find_by_email(users[:user3][:email]).id,
  sent_at: Time.now
)

user3.sent_messages.create(
  subject: 'First email ever',
  content: 'I am answering to the First seeded email',
  recipient_id: User.find_by_email(users[:user1][:email]).id,
  sent_at: Time.now,
  thread_id: 1
)

user3.sent_messages.create(
  subject: 'Second email',
  content: 'I am answering to the Second seeded email',
  recipient_id: User.find_by_email(users[:user2][:email]).id,
  sent_at: Time.now,
  thread_id: 2
)
