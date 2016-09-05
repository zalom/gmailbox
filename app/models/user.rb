class User < ApplicationRecord
  has_one :profile, dependent: :destroy

  has_many :received_messages, class_name: 'Message', foreign_key: 'recipient_id'
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id'
  has_many :messages, through: :message_flags
  has_many :message_flags, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  accepts_nested_attributes_for :profile

  validates :password, presence: true, length: { minimum: 5, maximum: 120 }, on: :create
  validates :password, length: { minimum: 5, maximum: 120 }, on: :update, allow_blank: true

  scope :find_all_but, -> (user) { where.not(id: user) }
end
