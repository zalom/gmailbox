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
user4 = User.find_by_email(users[:user4][:email])
user5 = User.find_by_email(users[:user5][:email])
user6 = User.find_by_email(users[:user6][:email])

# Zlatko -> Ervin (id: 1)
user1.sent_messages.create(
  subject: 'Pull request needed',
  content: 'First seeded email. Accept pull request.',
  recipient_id: User.find_by_email(users[:user3][:email]).id,
  sent_at: Time.now,
  is_draft: false
)

# Mirza -> Ervin (id: 2)
user2.sent_messages.create(
  subject: 'Pull request info',
  content: "Accept Zlaja's pull request.",
  recipient_id: User.find_by_email(users[:user3][:email]).id,
  sent_at: Time.now,
  is_draft: false
)

# Ervin -> Zlatko (thread) (id: 3)
user3.sent_messages.create(
  subject: 'Pull request needed',
  content: 'I am answering to the First seeded email. 
            Commits are not good. Pull request is not approved.',
  recipient_id: User.find_by_email(users[:user1][:email]).id,
  sent_at: Time.now,
  is_draft: false,
  thread_id: 1
)

# Ervin -> Mirza (thread) (id: 4)
user3.sent_messages.create(
  subject: 'Pull request info',
  content: 'I am answering to the Second seeded email. 
            Answered to Zlaja already.',
  recipient_id: User.find_by_email(users[:user2][:email]).id,
  sent_at: Time.now,
  is_draft: false,
  thread_id: 2
)

# Ervin -> Zlatko (id: 5)
user3.sent_messages.create(
  subject: 'Pull request fix bugs',
  content: 'Have you fixed the bugs? It is Important!',
  recipient_id: User.find_by_email(users[:user1][:email]).id,
  sent_at: Time.now,
  is_draft: false
)

# Zlatko -> Ervin (thread) (id: 6)
user1.sent_messages.create(
  subject: 'Pull request question',
  content: 'I am answering and marking your last email as Important.',
  recipient_id: User.find_by_email(users[:user3][:email]).id,
  sent_at: Time.now,
  is_draft: false,
  thread_id: 5
)

user1.messages.find(5).mark_important

# Ervin -> Zlatko (thread) (id: 7)
user3.sent_messages.create(
  subject: 'Pull request question',
  content: 'OK. I am waiting for the next message!',
  recipient_id: User.find_by_email(users[:user1][:email]).id,
  sent_at: Time.now,
  is_draft: false,
  thread_id: 5
)

# Enes -> Zlatko (id: 8)
user5.sent_messages.create(
  subject: 'Fix CSS!',
  content: 'CSS ... CSS ... CSS',
  recipient_id: User.find_by_email(users[:user1][:email]).id,
  sent_at: Time.now,
  is_draft: false
)

# Enes -> Zlatko (id: 9)
user5.sent_messages.create(
  subject: 'I said - Fix CSS!',
  content: 'CSS...CSS...CSS...CSS',
  recipient_id: User.find_by_email(users[:user1][:email]).id,
  sent_at: Time.now,
  is_draft: false
)

user1.trash_messages.create(user_id: user1.id,
                            message_id: user1.messages.find(8).id)

# Zlatko -> Enes (id: 10)
user1.sent_messages.create(
  subject: "I'll fix the css. OK!",
  content: 'It is not fair that only you can say CSS...CSS...CSS...CSS!',
  recipient_id: User.find_by_email(users[:user5][:email]).id,
  sent_at: Time.now,
  is_draft: false
)

user1.trash_messages.create(user_id: user1.id,
                            message_id: user1.messages.find(9).id)
user1.trash_messages.create(user_id: user1.id,
                            message_id: user1.sent_messages.find(10).id)

# Zlatko -> Mirza (id: 11)
user1.sent_messages.create(
  subject: 'First draft',
  content: 'SCRUM meeting is canceled!',
  recipient_id: User.find_by_email(users[:user2][:email]).id,
  is_draft: true
)

# Zlatko -> Sedad (id: 12)
user1.sent_messages.create(
  subject: 'Second draft',
  content: 'Hello Sedad, the weather is awesome!',
  is_draft: true
)

# Zlatko -> Jasmin (id: 13)
user1.sent_messages.create(
  subject: 'Third draft',
  content: 'Hello Jasmin, hope you are well!',
  is_draft: true
)

