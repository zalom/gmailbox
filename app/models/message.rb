class Message < ApplicationRecord
  belongs_to :thread, class_name: 'Message'
  has_many :replies, class_name: 'Message', foreign_key: 'thread_id'

  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  has_many :users, through: :message_flags
  has_many :message_flags

  scope :trash, -> (user) { where(id: [MessageFlag.include_trash(user)]) }
  scope :exclude_trash, -> (user) { where.not(id: [MessageFlag.include_trash(user)]) }
  scope :starred, -> (user) { where(id: [MessageFlag.include_starred(user)]) }
  scope :drafts, -> (user) { where(id: [MessageFlag.include_drafts(user)]) }
  scope :non_drafts, -> (user) { where.not(id: [MessageFlag.include_drafts(user)]) }
  scope :unread, -> (user) { where(id: [MessageFlag.include_unread(user)]) }

  scope :thread, -> { where thread_id: nil }

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
    message_flags.where(user_id: user_id).map(&:is_read)[0]
  end

  def mark_read(user_id, message_id)
    message_flags.where(user_id: user_id, message_id: message_id).update_all(is_read: true)
  end

  def self.mark_all_read(user_id)
    all.each do |message|
      message.message_flags.where(user_id: user_id, message_id: message.id).update_all(is_read: true)
    end
  end

  def mark_unread(user_id, message_id)
    message_flags.where(user_id: user_id, message_id: message_id).update_all(is_read: false)
  end

  def self.mark_all_unread(user_id)
    all.each do |message|
      message.message_flags.where(user_id: user_id, message_id: message.id).update_all(is_read: false)
    end
  end

  def starred?(user_id)
    message_flags.where(user_id: user_id).map(&:is_starred)[0]
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
