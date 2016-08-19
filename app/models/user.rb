class User < ApplicationRecord
  has_one :profile

  has_many :received_messages, class_name: 'Message', foreign_key: 'recipient_id'
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id'
  has_many :messages, through: :message_flags
  has_many :message_flags
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  scope :user_email, -> (email) { find_by_email(email) }
  accepts_nested_attributes_for :profile

  def self.matches_user_in_database
    exists?(email: email)
  end
end
