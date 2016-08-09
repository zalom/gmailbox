class Message < ApplicationRecord
  belongs_to :thread, class_name: 'Message'
  has_many :replies, class_name: 'Message', foreign_key: 'thread_id'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  has_many :trash_messages

  scope :important, -> { where(is_important: true) }
  scope :drafts, -> { where is_draft: true }
  scope :non_drafts, -> { where.not sent_at: nil }
  scope :unread, -> { where is_read: false }

  scope :exclude_trash, -> (user_id) { where.not id: TrashMessage.user_trash_ids(user_id) }
  scope :trash, -> (user_id) { where id: TrashMessage.user_trash_ids(user_id) }

  scope :in_reply_to, -> (message) { where thread: message, order: 'created_at'}

  def sender_email
    User.find(sender_id).email
  end

  def recipient_email
    recipient_id.nil? ? '' : User.find(recipient_id).email
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

  def mark_important
    is_important == true ? self.is_important = false : self.is_important = true
    save
  end

  def set_sent
    self.is_sent = Time.now if is_sent.nil?
  end

end
