users = {
  user1: { email: 'zlatko@example.com', password: '123456' },
  user2: { email: 'user1@example.com', password: '123456' },
  user3: { email: 'user2@example.com', password: '123456' },
  user4: { email: 'user3@example.com', password: '123456' },
  user5: { email: 'user4@example.com', password: '123456' },
  user6: { email: 'user5@example.com', password: '123456' }
}

users.each do |_k, v|
  User.create!(
    email: v[:email],
    password: v[:password],
    password_confirmation: v[:password],
    confirmed_at: DateTime.now
  )
end

user1 = User.find_by_email(users[:user1][:email]) # Zlatko
user2 = User.find_by_email(users[:user2][:email]) # user1
user3 = User.find_by_email(users[:user3][:email]) # user2
user4 = User.find_by_email(users[:user4][:email]) # user3
user5 = User.find_by_email(users[:user5][:email]) # user4
user6 = User.find_by_email(users[:user6][:email]) # user5

def print_notice(msg)
  puts 'message_id: ' + msg.message.id.to_s
  puts 'notice: ' + msg.notice
end

# Zlatko -> user2 (id: 1)
message_params = {
  subject: 'Pull request needed',
  content: 'First seeded email. Accept pull request.',
  recipient_email: user3.email
}
new_message = MessageCreate.new(user1, message_params)
new_message.create
print_notice(new_message)

# user1 -> user2 (id: 2)
message_params = {
  subject: 'Pull request info',
  content: "Accept Zlaja's pull request.",
  recipient_email: user3.email
}
new_message = MessageCreate.new(user2, message_params)
new_message.create
print_notice(new_message)

# user2 -> Zlatko (thread) (id: 3)
message_params = {
  subject: 'Pull request needed',
  content: 'I am answering to the First seeded email. 
            Commits are not good. Pull request is not approved.',
  recipient_email: user1.email,
  thread_id: 1
}
new_message = MessageCreate.new(user3, message_params)
new_message.create
print_notice(new_message)

# user2 -> user1 (thread) (id: 4)
message_params = {
  subject: 'Pull request info',
  content: 'I am answering to the Second seeded email. 
            Answered to Zlaja already.',
  recipient_email: user2.email,
  thread_id: 2
}
new_message = MessageCreate.new(user3, message_params)
new_message.create
print_notice(new_message)

# user2 -> Zlatko (id: 5)
message_params = {
  subject: 'Pull request fix bugs',
  content: 'Have you fixed the bugs? It is Important!',
  recipient_email: user1.email
}
new_message = MessageCreate.new(user3, message_params)
new_message.create
print_notice(new_message)

# Zlatko -> user2 (thread) (id: 6)
message_params = {
  subject: 'Pull request question',
  content: 'I am answering and marking your last email as Important.',
  recipient_email: user3.email,
  thread_id: 5
}
new_message = MessageCreate.new(user1, message_params)
new_message.create
print_notice(new_message)

# Mark starred for Zlatko on message_id = 5
user1.message_flags.mark_starred(user1, 5)

# user2 -> Zlatko (thread) (id: 7)
message_params = {
  subject: 'Pull request question',
  content: 'OK. I am waiting for the next message!',
  recipient_email: user1.email,
  thread_id: 5
}
new_message = MessageCreate.new(user3, message_params)
new_message.create
print_notice(new_message)

# user5 -> Zlatko (id: 8)
message_params = {
  subject: 'Fix CSS!',
  content: 'CSS ... CSS ... CSS',
  recipient_email: user1.email
}
new_message = MessageCreate.new(user5, message_params)
new_message.create
print_notice(new_message)

# user5 -> Zlatko (id: 9)
message_params = {
  subject: 'I said - Fix CSS!',
  content: 'CSS...CSS...CSS...CSS',
  recipient_email: user1.email
}
new_message = MessageCreate.new(user5, message_params)
new_message.create
print_notice(new_message)

# Move unread message with id: 8 to Trash for Zlatko
user1.message_flags.mark_as_trash(user1, 8)

# Mark as read message with id: 9 and move to Trash for Zlatko
user1.message_flags.mark_read(user1, 9)
user1.message_flags.mark_as_trash(user1, 9)

# Zlatko -> user5 (id: 10)
message_params = {
  subject: "I'll fix the css. OK!",
  content: 'It is not fair that only you can say CSS...CSS...CSS...CSS!',
  recipient_email: user5.email
}
new_message = MessageCreate.new(user1, message_params)
new_message.create
print_notice(new_message)

# user5 -> Zlatko (thread) (id: 11)
message_params = {
  subject: "I'll fix the css. OK!",
  content: 'I am only answering because you are testing messages!',
  recipient_email: user1.email,
  thread_id: 10
}
new_message = MessageCreate.new(user5, message_params)
new_message.create
print_notice(new_message)

# Zlatko -> user1 (draft) (id: 12)
message_params = {
  subject: 'First draft',
  content: 'SCRUM meeting is canceled!',
  recipient_email: user2.email,
  draft: true
}
new_message = MessageCreate.new(user1, message_params)
new_message.create
print_notice(new_message)

# Zlatko -> Sedad (id: 13)
message_params = {
  subject: 'Second draft',
  content: 'Hello Sedad, the weather is awesome!',
  draft: true
}
new_message = MessageCreate.new(user1, message_params)
new_message.create
print_notice(new_message)

# Zlatko -> user5 (id: 14)
message_params = {
  subject: 'Third draft',
  content: 'Hello user5, hope you are well!',
  draft: true
}
new_message = MessageCreate.new(user1, message_params)
new_message.create
print_notice(new_message)
