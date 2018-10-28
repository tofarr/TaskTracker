class UserTag < ApplicationRecord
  validates :title, presence: true
  has_one_attached :icon
end
