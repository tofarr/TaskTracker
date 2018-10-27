class User < ApplicationRecord

  max_paginates_per 100
  has_secure_password


  def title
    name || username || email
  end
end
