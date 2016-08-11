class Message < ApplicationRecord
  belongs_to :thread, class_name: 'Message'
  has_many :replies, class_name: 'Message', foreign_key: 'thread_id'

  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  has_many :users, through: :message_flags
  has_many :message_flags

  scope :trash, -> (user) { where(id: [MessageFlag.include_trash(user)]) }
  scope :exclude_trash, -> (user) { where.not(id: [MessageFlag.include_trash(user)]) }
  scope :important, -> (user) { where(id: [MessageFlag.include_important(user)]) }
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

  def read?(user)
    message_flags.read?(user)
  end
end
