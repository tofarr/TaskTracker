class User < ApplicationRecord

  max_paginates_per 100
  has_secure_password
  has_one_attached :avatar

  validates :username, presence: true

  def title
    name || username || email
  end
end
