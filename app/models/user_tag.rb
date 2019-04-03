class UserTag < ApplicationRecord
  validates :title, presence: true
  has_one_attached :icon
  has_many :user_tag_mutex
  has_many :mutex, through: :user_tag_mutex, dependent: :destroy

end
