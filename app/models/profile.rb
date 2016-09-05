class Profile < ApplicationRecord
  belongs_to :user
  validates :username, presence: true, length: { in: 3..20 }
  validates :first_name, presence: true
  validates :last_name, presence: true

  def full_name
    first_name + ' ' + last_name
  end
end
