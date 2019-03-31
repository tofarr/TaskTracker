class User < ApplicationRecord

  max_paginates_per 100
  has_secure_password
  has_one_attached :avatar
  has_and_belongs_to_many :tags, class_name: "UserTag"

  validates :username, presence: true

  has_many :assigned_tasks, :foreign_key => :assigned_user_id, :class_name => "Task", :dependent => :nullify
  has_many :created_tasks, :foreign_key => :created_user_id, :class_name => "Task", :dependent => :nullify
  has_many :comments, :dependent => :destroy
  has_many :attachments, :dependent => :destroy

  def title
    name || username || email
  end
end
