class User < ApplicationRecord

  max_paginates_per 100
  has_secure_password
  has_one_attached :avatar
  has_and_belongs_to_many :tags, class_name: "UserTag"

  validates :username, presence: true

  def title
    name || username || email
  end
end
