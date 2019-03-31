class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :task
  has_one_attached :data

  def self.viewable_comments(user)
    return Comment.all if user.admin?
    Comment.joins(:task).where("commentable=true and (viewable=true or created_user_id=? or assigned_user_id=?)", user.id, user.id)
  end

  def self.editable_comments(user)
    return Comment.all if user.admin?
    Comment.where(user_id: user).joins(:task).where("commentable=true")
  end

  def is_img?
    type = data.attachment && data.content_type
    type == "image/jpg" || type == "image/jpeg" || type == "image/gif" || type == "image/png"
  end

  def editable_by?(user)
    self.user == user || user.admin?
  end

end
