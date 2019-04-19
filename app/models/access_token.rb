class AccessToken < ApplicationRecord
  belongs_to :user
  validates :token, presence: true

  after_initialize :set_token_default

  def self.active_access_tokens
    AccessToken.where(suspended: false).where('expires_at IS NULL or expires_at > ?', Time.now)
  end

  def set_token_default
    self.token ||= SecureRandom.base64(44) if has_attribute?(:token) # > 256 bits
  end

end
