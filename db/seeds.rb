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
  sent_at: Time.now
)

# Set Flags for Zlatko on message_id = 1
user1.sent_messages.find(1).message_flags.create(
  user_id: user1.id,
  is_draft: false,
  is_read: true
)

# TODO: After Create callback for recipient_id needed
# Set Flags for Ervin on message_id = 1 (is_read: false)
Message.find(1).message_flags.create(
  user_id: Message.find(1).recipient_id
)

# Mirza -> Ervin (id: 2)
user2.sent_messages.create(
  subject: 'Pull request info',
  content: "Accept Zlaja's pull request.",
  recipient_id: User.find_by_email(users[:user3][:email]).id,
  sent_at: Time.now
)

# Set Flags for Mirza on message_id = 2
user2.sent_messages.find(2).message_flags.create(
  user_id: user2.id,
  is_draft: false,
  is_read: true
)

# TODO: After Create callback for recipient_id needed
# Set Flags for Ervin on message_id = 2 (is_read: false)
Message.find(2).message_flags.create(
  user_id: Message.find(2).recipient_id
)

# Ervin -> Zlatko (thread) (id: 3)
user3.sent_messages.create(
  subject: 'Pull request needed',
  content: 'I am answering to the First seeded email. 
            Commits are not good. Pull request is not approved.',
  recipient_id: User.find_by_email(users[:user1][:email]).id,
  sent_at: Time.now,
  thread_id: 1
)

# Set Flags for Ervin on message_id = 3
user3.sent_messages.find(3).message_flags.create(
  user_id: user3.id,
  is_draft: false,
  is_read: true
)

# TODO: After Create callback for recipient_id needed
# Set Flags for Zlatko on message_id = 3 (is_read: false)
Message.find(3).message_flags.create(
  user_id: Message.find(3).recipient_id
)

# Ervin -> Mirza (thread) (id: 4)
user3.sent_messages.create(
  subject: 'Pull request info',
  content: 'I am answering to the Second seeded email. 
            Answered to Zlaja already.',
  recipient_id: User.find_by_email(users[:user2][:email]).id,
  sent_at: Time.now,
  thread_id: 2
)

# Set Flags for Ervin on message_id = 4
user3.sent_messages.find(4).message_flags.create(
  user_id: user3.id,
  is_draft: false,
  is_read: true
)

# TODO: After Create callback for recipient_id needed
# Set Flags for Mirza on message_id = 4 (is_read: false)
Message.find(4).message_flags.create(
  user_id: Message.find(4).recipient_id
)

# Ervin -> Zlatko (id: 5)
user3.sent_messages.create(
  subject: 'Pull request fix bugs',
  content: 'Have you fixed the bugs? It is Important!',
  recipient_id: User.find_by_email(users[:user1][:email]).id,
  sent_at: Time.now
)

# Set Flags for Ervin on message_id = 5
user3.sent_messages.find(5).message_flags.create(
  user_id: user3.id,
  is_draft: false,
  is_read: true
)

# TODO: After Create callback for recipient_id needed
# Set Flags for Mirza on message_id = 5 (is_read: false)
Message.find(5).message_flags.create(
  user_id: Message.find(5).recipient_id
)

# Zlatko -> Ervin (thread) (id: 6)
user1.sent_messages.create(
  subject: 'Pull request question',
  content: 'I am answering and marking your last email as Important.',
  recipient_id: User.find_by_email(users[:user3][:email]).id,
  sent_at: Time.now,
  thread_id: 5
)

# Set Flags for Zlatko on message_id = 6
user1.sent_messages.find(6).message_flags.create(
  user_id: user1.id,
  is_draft: false,
  is_read: true
)

# Mark important for Zlatko on message_id = 5
user1.messages.find(5).message_flags.where(user_id: user1.id).update_all(
  is_important: true
)

# TODO: After Create callback for recipient_id needed
# Set Flags for Ervin on message_id = 6 (is_read: false)
Message.find(6).message_flags.create(
  user_id: Message.find(6).recipient_id
)

# Ervin -> Zlatko (thread) (id: 7)
user3.sent_messages.create(
  subject: 'Pull request question',
  content: 'OK. I am waiting for the next message!',
  recipient_id: User.find_by_email(users[:user1][:email]).id,
  sent_at: Time.now,
  thread_id: 5
)

# Set Flags for Ervin on message_id = 7
user3.sent_messages.find(7).message_flags.create(
  user_id: user3.id,
  is_draft: false,
  is_read: true
)

# TODO: After Create callback for recipient_id needed
# Set Flags for Zlatko on message_id = 7 (is_read: false)
Message.find(7).message_flags.create(
  user_id: Message.find(7).recipient_id
)

# Enes -> Zlatko (id: 8)
user5.sent_messages.create(
  subject: 'Fix CSS!',
  content: 'CSS ... CSS ... CSS',
  recipient_id: User.find_by_email(users[:user1][:email]).id,
  sent_at: Time.now
)

# Set Flags for Enes on message_id = 8
user5.sent_messages.find(8).message_flags.create(
  user_id: user5.id,
  is_draft: false,
  is_read: true
)

# TODO: After Create callback for recipient_id needed
# Set Flags for Zlatko on message_id = 8 (is_read: false)
Message.find(8).message_flags.create(
  user_id: Message.find(8).recipient_id
)

# Enes -> Zlatko (id: 9)
user5.sent_messages.create(
  subject: 'I said - Fix CSS!',
  content: 'CSS...CSS...CSS...CSS',
  recipient_id: User.find_by_email(users[:user1][:email]).id,
  sent_at: Time.now
)

# Set Flags for Enes on message_id = 9
user5.sent_messages.find(9).message_flags.create(
  user_id: user5.id,
  is_draft: false,
  is_read: true
)

# TODO: After Create callback for recipient_id needed
# Set Flags for Zlatko on message_id = 9 (is_read: false)
Message.find(9).message_flags.create(
  user_id: Message.find(9).recipient_id
)

# Move to Trash message with id: 8 for Zlatko
user1.messages.find(8).message_flags.where(user_id: user1.id).update_all(
  is_trash: true
)

# Mark as read message with id: 9 and move to Trash for Zlatko
user1.messages.find(9).message_flags.where(user_id: user1.id).update_all(
  is_read: true,
  is_trash: true
)

# Zlatko -> Enes (id: 10)
user1.sent_messages.create(
  subject: "I'll fix the css. OK!",
  content: 'It is not fair that only you can say CSS...CSS...CSS...CSS!',
  recipient_id: User.find_by_email(users[:user5][:email]).id,
  sent_at: Time.now
)

# Set Flags for Zlatko on message_id = 10
user1.sent_messages.find(10).message_flags.create(
  user_id: user1.id,
  is_draft: false,
  is_read: true
)

# TODO: After Create callback for recipient_id needed
# Set Flags for Enes on message_id = 10 (is_read: false)
Message.find(10).message_flags.create(
  user_id: Message.find(10).recipient_id
)

# Zlatko -> Mirza (id: 11)
user1.sent_messages.create(
  subject: 'First draft',
  content: 'SCRUM meeting is canceled!',
  recipient_id: User.find_by_email(users[:user2][:email]).id
)

# Set Flags for Zlatko on message_id = 11
user1.sent_messages.find(11).message_flags.create(
  user_id: user1.id,
  is_read: true
)

# Zlatko -> Sedad (id: 12)
user1.sent_messages.create(
  subject: 'Second draft',
  content: 'Hello Sedad, the weather is awesome!'
)

# Set Flags for Zlatko on message_id = 12
user1.sent_messages.find(12).message_flags.create(
  user_id: user1.id,
  is_read: true
)

# Zlatko -> Jasmin (id: 13)
user1.sent_messages.create(
  subject: 'Third draft',
  content: 'Hello Jasmin, hope you are well!'
)

# Set Flags for Zlatko on message_id = 11
user1.sent_messages.find(13).message_flags.create(
  user_id: user1.id,
  is_read: true
)
