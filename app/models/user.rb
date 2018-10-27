class User < ApplicationRecord

  max_paginates_per 100
  has_secure_password
  has_one_attached :avatar


  def title
    name || username || email
  end
end
