class Message < ApplicationRecord
  belongs_to :thread, class_name: 'Message'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'

  has_many :replies, class_name: 'Message', foreign_key: 'thread_id'
  has_many :users, through: :message_flags
  has_many :message_flags

  # Scopes on model
  scope :only_threads, -> { where thread_id: nil }

  # Joined model scopes
  scope :join_flags,      -> { joins(:message_flags) }
  scope :include_trash,   -> { where('message_flags.is_trash = ?', true) }
  scope :exclude_trash,   -> { where('message_flags.is_trash = ?', false) }
  scope :include_starred, -> { where('message_flags.is_starred = ?', true) }
  scope :include_drafts,  -> (user_id) { where('message_flags.is_draft = ? AND message_flags.user_id = ?', true, user_id) }
  scope :exclude_drafts,  -> { where('message_flags.is_draft = ?', false) }
  scope :include_unread,  -> { where('message_flags.is_read = ?', false) }
  scope :exclude_unread,  -> { where('message_flags.is_read = ?', true) }

  scope :exclude_others,  -> { exclude_trash.exclude_drafts }

  scope :trash,   -> { only_threads.include_trash }
  scope :unread,  -> { only_threads.exclude_trash.include_unread }
  scope :starred, -> { only_threads.exclude_trash.include_starred }
  scope :drafts,  -> (user_id) { only_threads.join_flags.include_drafts(user_id) }
  scope :sent,    -> (user_id) { join_flags.exclude_trash.exclude_drafts.where('message_flags.user_id = ?', user_id) }

  scope :exclude_replies, lambda {
    joins(:message_flags)
      .merge(exclude_others)
  }

  # Multiple joined model scopes
  scope :include_replies, lambda {
    joins(:message_flags, :replies)
      .merge(exclude_others)
  }

  def sender_email
    User.find(sender_id).email
  end

  def recipient_email
    recipient_id.nil? ? '' : User.find(recipient_id).email
  end

  def set_sent
    self.is_sent = Time.now if is_sent.nil?
  end

  def self.ordered
    order('created_at asc')
  end

  def read?(user_id)
    message_flags.where(user_id: user_id).try(:first).is_read
  end

  def mark_read(user_id)
    message_flags.where(user_id: user_id).update_all(is_read: true)
  end

  def self.mark_all_read(user_id)
    all.each do |message|
      message.message_flags.where(user_id: user_id, message_id: message.id).update_all(is_read: true)
    end
  end

  def mark_unread(user_id)
    message_flags.where(user_id: user_id).update_all(is_read: false)
  end

  def self.mark_all_unread(user_id)
    all.each do |message|
      message.message_flags.where(user_id: user_id, message_id: message.id).update_all(is_read: false)
    end
  end

  def starred?(user_id)
    message_flags.where(user_id: user_id).try(:first).is_starred
  end

  def mark_starred(user_id, message_id)
    message_flags.where(user_id: user_id, message_id: message_id).update_all(is_starred: true)
  end

  def self.mark_all_starred(user_id)
    all.each do |message|
      message.message_flags.where(user_id: user_id, message_id: message.id).update_all(is_starred: true)
    end
  end

  def mark_unstarred(user_id, message_id)
    message_flags.where(user_id: user_id, message_id: message_id).update_all(is_starred: false)
  end

  def self.mark_all_unstarred(user_id)
    all.each do |message|
      message.message_flags.where(user_id: user_id, message_id: message.id).update_all(is_starred: false)
    end
  end
end
