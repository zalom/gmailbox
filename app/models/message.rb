class Message < ApplicationRecord
  belongs_to :thread, class_name: 'Message'
  has_many :thread_messages, class_name: 'Message', foreign_key: 'thread_id'

  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'

  scope :unread, -> { where is_read: false }
  scope :important, -> { where is_important: true }
  scope :drafts, -> { where is_draft: true }

  def sender_email
    User.find(sender_id).email
  end

  def mark_read
    return unless is_read.nil? || is_read == false
    self.is_read = true
    save
  end

  def mark_unread
    return unless is_read.nil? || is_read == true
    self.is_read = false
    save
  end
end
