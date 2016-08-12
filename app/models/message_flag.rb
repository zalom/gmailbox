class MessageFlag < ApplicationRecord
  belongs_to :message
  belongs_to :user

  scope :include_trash, -> (user) { where(user_id: user.id, is_trash: true).map(&:message_id) }
  scope :include_important, -> (user) { where(user_id: user.id, is_important: true, is_trash: false).map(&:message_id) }
  scope :include_drafts, -> (user) { where(user_id: user.id, is_draft: true, is_trash: false).map(&:message_id) }
  scope :include_unread, -> (user) { where(user_id: user.id, is_read: false, is_trash: false).map(&:message_id) }
end
