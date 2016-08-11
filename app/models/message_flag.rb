class MessageFlag < ApplicationRecord
  belongs_to :message
  belongs_to :user

  scope :include_trash, -> (user) { where(user_id: user.id, is_trash: true).map(&:message_id) }
  scope :include_important, -> (user) { where(user_id: user.id, is_important: true, is_trash: false).map(&:message_id) }
  scope :include_drafts, -> (user) { where(user_id: user.id, is_draft: true, is_trash: false).map(&:message_id) }
  scope :include_unread, -> (user) { where(user_id: user.id, is_read: true, is_trash: false).map(&:message_id) }

  def self.mark_read
    return unless is_read.nil? || is_read == false
    self.is_read = true
    save
  end

  def self.mark_all_read
    update_all(is_read: true)
  end

  def mark_unread
    return unless is_read.nil? || is_read == true
    self.is_read = false
    save
  end

  def self.mark_all_unread
    update_all(is_read: false)
  end

  def self.mark_important
    is_important == true ? self.is_important = false : self.is_important = true
    save
  end

  def self.read?(user)
    where(user_id: user.id).map(&:is_read)[0]
  end
end
