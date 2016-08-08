class TrashMessage < ApplicationRecord
  belongs_to :message
  belongs_to :user
  delegate :trash_ids, :user_trash_ids, to: :message
  scope :trash_ids, -> { TrashMessage.all.map(&:message_id) }
  scope :user_trash_ids, -> (user_id) { where(user_id: user_id).map(&:message_id) }
end
