class MessageFlag < ApplicationRecord
  belongs_to :message
  belongs_to :user

  def self.mark_read(user, thread_ids)
    where(user_id: user).where(message_id: thread_ids).update_all(is_read: true)
  end

  def self.mark_unread(user, thread_ids)
    where(user_id: user).where(message_id: thread_ids).update_all(is_read: false)
  end

  def self.mark_starred(user, thread_ids)
    where(user_id: user).where(message_id: thread_ids).update_all(is_starred: true)
  end

  def self.mark_unstarred(user, thread_ids)
    where(user_id: user).where(message_id: thread_ids).update_all(is_starred: false)
  end

  def self.mark_as_trash(user, thread_ids)
    where(user_id: user).where(message_id: thread_ids).update_all(is_trash: true)
  end

  def self.remove_from_trash(user, thread_ids)
    where(user_id: user).where(message_id: thread_ids).update_all(is_trash: false)
  end
end
