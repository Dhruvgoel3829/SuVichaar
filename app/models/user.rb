class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :announcements, dependent: :destroy

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validate :username_unchangeable, on: :update

  private

  def username_unchangeable
    if username_changed? && self.persisted?
      errors.add(:username, "cannot be changed once set")
    end
  end
end
