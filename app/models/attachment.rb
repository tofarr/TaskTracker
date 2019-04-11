class Attachment < ApplicationRecord

  belongs_to :user
  belongs_to :task
  has_one_attached :data

  def self.viewable_attachments(user)
    return Attachment.none if user.suspended?
    return Attachment.all if user.admin?
    Attachment.joins(:task).where("viewable=true or created_by_user_id=? or assigned_user_id=?", user.id, user.id)
  end

  def self.editable_attachments(user)
    return Attachment.none if user.suspended?
    return Attachment.all if user.admin?
    Attachment.joins(:task).where("editable=true or created_by_user_id=? or assigned_user_id=?", user.id, user.id)
  end

  def is_img?
    type = data.attachment && data.content_type
    type == "image/jpg" || type == "image/jpeg" || type == "image/gif" || type == "image/png"
  end

  def editable_by?(user)
    return false if user.suspended?
    self.user == user || user.admin?
  end
end
