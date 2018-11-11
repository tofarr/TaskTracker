class Attachment < ApplicationRecord

  belongs_to :user
  belongs_to :task
  has_one_attached :data


  def is_img?
    type = data.attachment && data.content_type
    type == "image/jpg" || type == "image/jpeg" || type == "image/gif" || type == "image/png"
  end

  def editable_by?(user)
    self.user == user || user.admin?
  end
end
