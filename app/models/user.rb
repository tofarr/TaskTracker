class User < ApplicationRecord

  has_secure_password


  def title
    name || username || email
  end
end
