class Profile < ApplicationRecord
  belongs_to :user
  validates :username, presence: true, length: { in: 6..20 }
  validates :first_name, presence: true
  validates :last_name, presence: true
end
