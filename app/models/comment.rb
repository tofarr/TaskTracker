class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :task

  def editable_by?(user)
    self.user == user || user.admin?
  end

end
