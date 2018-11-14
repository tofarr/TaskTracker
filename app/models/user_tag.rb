class UserTag < ApplicationRecord
  validates :title, presence: true
  has_one_attached :icon
  has_many :user_tag_mutex
  has_many :mutex, through: :user_tag_mutex, dependent: :destroy

  def self.check_mutex(tags)
    ret = tags.to_a
    tags.each do |tag|
      raise ApplicationController::NotAuthorized unless (tags & tag.mutex).empty?
    end
    ret
  end
end
