class User < ApplicationRecord

  max_paginates_per 100
  has_secure_password validations: false
  has_one_attached :avatar
  has_and_belongs_to_many :tags, class_name: "UserTag"

  validates :username, presence: true

  has_many :assigned_tasks, :foreign_key => :assigned_user_id, :class_name => "Task", :dependent => :nullify
  has_many :created_tasks, :foreign_key => :created_user_id, :class_name => "Task", :dependent => :nullify
  has_many :comments, :dependent => :destroy
  has_many :attachments, :dependent => :destroy
  has_many :access_tokens, :dependent => :destroy

  validate :check_tag_mutex

  after_create :add_first_access_token
  after_update :clear_tokens_after_password_change

  def title
    name || username || email
  end

  def check_tag_mutex
    tags.each do |tag|
      errors.add(:tags, "Must be viewable to be editable!") unless (tags & tag.mutex).empty?
    end
  end

  def active_access_tokens
    access_tokens.where(suspended: false).where('expires_at IS NULL or expires_at > ?', Time.now)
  end

  def add_first_access_token
    AccessToken.create(title: 'Initial Login Token', user_id: id)
  end

  def clear_tokens_after_password_change
    authentication_tokens.destroy_all if self.password_digest_changed?
  end
end
