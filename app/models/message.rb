class Message < ApplicationRecord
  belongs_to :thread, class_name: 'Message'
  has_many :thread_messages, class_name: 'Message', foreign_key: 'thread_id'

  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'

  scope :unread, -> { where is_read: false }
  scope :important, -> { where is_important: true }
  scope :drafts, -> { where is_draft: true }
end
