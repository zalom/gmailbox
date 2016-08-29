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

def print_notice(msg)
  puts 'message_id: ' + msg.message.id.to_s
  puts 'notice: ' + msg.notice
end

# Zlatko -> Ervin (id: 1)
message_params = {
  subject: 'Pull request needed',
  content: 'First seeded email. Accept pull request.',
  recipient_email: user3.email
}
message = MessageCreate.new(user1, message_params)
message.create
print_notice(message)

# Mirza -> Ervin (id: 2)
message_params = {
  subject: 'Pull request info',
  content: "Accept Zlaja's pull request.",
  recipient_email: user3.email
}
message = MessageCreate.new(user2, message_params)
message.create
print_notice(message)

# Ervin -> Zlatko (thread) (id: 3)
message_params = {
  subject: 'Pull request needed',
  content: 'I am answering to the First seeded email. 
            Commits are not good. Pull request is not approved.',
  recipient_email: user1.email,
  thread_id: 1
}
message = MessageCreate.new(user3, message_params)
message.create
print_notice(message)

# Ervin -> Mirza (thread) (id: 4)
message_params = {
  subject: 'Pull request info',
  content: 'I am answering to the Second seeded email. 
            Answered to Zlaja already.',
  recipient_email: user2.email,
  thread_id: 2
}
message = MessageCreate.new(user3, message_params)
message.create
print_notice(message)

# Ervin -> Zlatko (id: 5)
message_params = {
  subject: 'Pull request fix bugs',
  content: 'Have you fixed the bugs? It is Important!',
  recipient_email: user1.email
}
message = MessageCreate.new(user3, message_params)
message.create
print_notice(message)

# Zlatko -> Ervin (thread) (id: 6)
message_params = {
  subject: 'Pull request question',
  content: 'I am answering and marking your last email as Important.',
  recipient_email: user3.email,
  thread_id: 5
}
message = MessageCreate.new(user1, message_params)
message.create
print_notice(message)

# Mark starred for Zlatko on message_id = 5
message.message.mark_starred(user1)

# Ervin -> Zlatko (thread) (id: 7)
message_params = {
  subject: 'Pull request question',
  content: 'OK. I am waiting for the next message!',
  recipient_email: user1.email,
  thread_id: 5
}
message = MessageCreate.new(user3, message_params)
message.create
print_notice(message)

# Enes -> Zlatko (id: 8)
message_params = {
  subject: 'Fix CSS!',
  content: 'CSS ... CSS ... CSS',
  recipient_email: user1.email
}
message = MessageCreate.new(user5, message_params)
message.create
print_notice(message)

# Enes -> Zlatko (id: 9)
message_params = {
  subject: 'I said - Fix CSS!',
  content: 'CSS...CSS...CSS...CSS',
  recipient_email: user1.email
}
message = MessageCreate.new(user5, message_params)
message.create
print_notice(message)

# Move unread message with id: 8 to Trash for Zlatko
user1.messages.find(8).mark_as_trash(user1)

# Mark as read message with id: 9 and move to Trash for Zlatko
user1.messages.find(9).mark_read(user1)
user1.messages.find(9).mark_as_trash(user1)

# Zlatko -> Enes (id: 10)
message_params = {
  subject: "I'll fix the css. OK!",
  content: 'It is not fair that only you can say CSS...CSS...CSS...CSS!',
  recipient_email: user5.email
}
message = MessageCreate.new(user1, message_params)
message.create
print_notice(message)

# Enes -> Zlatko (thread) (id: 11)
message_params = {
  subject: "I'll fix the css. OK!",
  content: 'I am only answering because you are testing messages!',
  recipient_email: user1.email,
  thread_id: 10
}
message = MessageCreate.new(user5, message_params)
message.create
print_notice(message)

# Zlatko -> Mirza (draft) (id: 12)
message_params = {
  subject: 'First draft',
  content: 'SCRUM meeting is canceled!',
  recipient_email: user2.email,
  draft: true
}
message = MessageCreate.new(user1, message_params)
message.create
print_notice(message)

# Zlatko -> Sedad (id: 13)
message_params = {
  subject: 'Second draft',
  content: 'Hello Sedad, the weather is awesome!',
  draft: true
}
message = MessageCreate.new(user1, message_params)
message.create
print_notice(message)

# Zlatko -> Jasmin (id: 14)
message_params = {
  subject: 'Third draft',
  content: 'Hello Jasmin, hope you are well!',
  draft: true
}
message = MessageCreate.new(user1, message_params)
message.create
print_notice(message)
