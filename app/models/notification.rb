class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :task, optional: true
  belongs_to :created_by_user, class_name: "User"

  validates :message, presence: true

  def self.editable_notifications(user)
    viewable_notifications(user)
  end

  def self.viewable_notifications(user)
    return Notification.none if user.suspended?
    Notification.where(user: user)
  end

  def title
    return "Re:#{task.identifier} on #{created_at.format("%Y-%m-%d %H:%M")}" if task.identifier
    return "From:#{user.title} on #{created_at.format("%Y-%m-%d %H:%M")}" if user.title
    "Message on #{created_at.format("%Y-%m-%d %H:%M")}"
  end

  def viewable_by?(user)
    return false if user.suspended?
    self.user == user
  end

  def editable_by?(user)
    viewable_by?(user)
  end

end
