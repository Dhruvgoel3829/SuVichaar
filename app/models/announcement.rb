class Announcement < ApplicationRecord
  # belongs_to :user, optional: true
  belongs_to :user

  validates :title, presence: true
  validates :posted_on, presence: true
  validates :user_id, presence: true
  validates :content, presence: true
end
