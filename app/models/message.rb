class Message < ApplicationRecord
  before_create :set_subject_if_empty

  belongs_to :thread, class_name: 'Message'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'

  has_many :replies, class_name: 'Message', foreign_key: 'thread_id'
  has_many :users, through: :message_flags
  has_many :message_flags

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
  scope :ordered,         -> { includes(:message_flags).order('message_flags.is_read, message_flags.updated_at desc') }
  scope :ordered_replies, -> { order('updated_at asc') }

  scope :exclude_trash_and_drafts, -> { only_threads.exclude_trash.exclude_drafts }

  scope :trash,   -> { only_threads.include_trash }
  scope :unread,  -> { only_threads.exclude_trash.include_unread }
  scope :starred, -> { only_threads.exclude_trash.include_starred }
  scope :drafts,  -> (user_id) { only_threads.join_flags.include_drafts(user_id) }
  scope :sent,    -> (user_id) { only_threads.join_flags.exclude_trash_and_drafts.where('message_flags.user_id = ?', user_id) }

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
    recipient_id.nil? ? '' : User.find_by_email(recipient_id).email
  end

  def recipient_email=(email)
    self.recipient_id = User.find_by_email(email).id
  end

  def read?(user_id)
    check_for_thread.message_flags.where(user_id: user_id).try(:first).is_read
  end

  def starred?(user_id)
    check_for_thread.message_flags.where(user_id: user_id).try(:first).is_starred
  end

  def mark_read(user_id)
    check_for_thread.message_flags.where(user_id: user_id, message_id: id).update_all(is_read: true)
  end

  def mark_unread(user_id)
    check_for_thread.message_flags.where(user_id: user_id, message_id: id).update_all(is_read: false)
  end

  def mark_starred(user_id)
    check_for_thread.message_flags.where(user_id: user_id, message_id: id).update_all(is_starred: true)
  end

  def mark_unstarred(user_id)
    check_for_thread.message_flags.where(user_id: user_id, message_id: id).update_all(is_starred: false)
  end

  def mark_as_trash(user_id)
    check_for_thread.message_flags.where(user_id: user_id, message_id: id).update_all(is_trash: true)
  end

  def remove_from_trash(user_id)
    check_for_thread.message_flags.where(user_id: user_id, message_id: id).update_all(is_trash: false)
  end

  def self.mark_all_read(user_id)
    all.each do |message|
      message.mark_read(user_id)
    end
  end

  def self.mark_all_unread(user_id)
    all.each do |message|
      message.mark_unread(user_id)
    end
  end

  def self.mark_all_starred(user_id)
    all.each do |message|
      message.mark_starred(user_id)
    end
  end

  def self.mark_all_unstarred(user_id)
    all.each do |message|
      message.mark_unstarred(user_id)
    end
  end

  def self.mark_all_trash(user_id)
    all.each do |message|
      message.mark_as_trash(user_id)
    end
  end

  def self.remove_all_from_trash(user_id)
    all.each do |message|
      message.remove_from_trash(user_id)
    end
  end

  protected

  def check_for_thread
    thread.nil? ? self : thread
  end

  private

  def set_subject_if_empty
    self.subject = 'no subject' if subject.blank?
  end
end
