class Sprint < ApplicationRecord

  has_and_belongs_to_many :users
  has_and_belongs_to_many :tasks

  validates :title, presence: true
  validates :users, presence: true
  validates :tasks, presence: true

  validates :start_at, presence: true
  validates :finish_at, presence: true
  validate :check_start_before_finish

  def self.editable_sprints(user)
    (user.admin? && (!user.suspended?)) ? Sprint.all : Sprint.none
  end

  def self.viewable_sprints(user)
    return Sprint.none if user.suspended?
    return Sprint.all if user.admin?
    Sprint.includes(:users).where(users: {id: user.id})
  end

  def viewable_by?(user)
    return false if user.suspended?
    user.admin? || users.include(user)
  end

  def editable_by?(user)
    return false if user.suspended?
    user.admin?
  end


  def check_start_before_finish
    if  start_at && finish_at && start_at > finish_at
      errors.add(:finish_at, "Finish must be after start")
    end
  end
end
