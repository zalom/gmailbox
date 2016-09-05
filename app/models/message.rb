class Message < ApplicationRecord
  before_create :set_subject_if_empty

  belongs_to :thread, class_name: 'Message'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'

  has_many :replies, class_name: 'Message', foreign_key: 'thread_id'
  has_many :users, through: :message_flags
  has_many :message_flags, dependent: :destroy

  attr_accessor :recipient_email, :draft

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

  scope :exclude_deleted, -> { where('message_flags.is_deleted = ?', false) }

  scope :ordered,         -> { order('message_flags.is_read, message_flags.updated_at desc') }
  scope :ordered_replies, -> { order('created_at asc') }

  scope :exclude_trash_and_drafts, -> { only_threads.exclude_trash.exclude_drafts }

  scope :trash,   -> { only_threads.include_trash.exclude_deleted }
  scope :unread,  -> { only_threads.exclude_trash.include_unread.exclude_deleted }
  scope :starred, -> { only_threads.exclude_trash.include_starred.exclude_trash.exclude_deleted }
  scope :drafts,  -> (user_id) { only_threads.join_flags.include_drafts(user_id).exclude_trash.exclude_deleted }
  scope :sent,    -> (user_id) { only_threads.join_flags.exclude_trash_and_drafts.where('message_flags.user_id = ?', user_id).exclude_deleted }

  scope :exclude_other, lambda {
    joins(:message_flags)
      .merge(exclude_trash)
      .merge(exclude_drafts)
  }

  # Multiple joined model scopes
  scope :include_replies, lambda {
    joins(:message_flags, :replies)
      .merge(exclude_trash_and_drafts)
  }

  def sender_email
    User.find(sender_id).email
  end

  def recipient_email
    recipient_id.nil? ? '' : User.find(recipient_id).email
  end

  def read?(user_id)
    find_thread.message_flags.where(user_id: user_id).try(:first).is_read
  end

  def starred?(user_id)
    find_thread.message_flags.where(user_id: user_id).try(:first).is_starred
  end

  def find_thread
    thread.nil? ? self : thread
  end

  private

  def set_subject_if_empty
    self.subject = 'no subject' if subject.blank?
  end
end
