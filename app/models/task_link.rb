# app/models/match.rb
class TaskLink < ApplicationRecord

  def self.link_types
     %w(link duplicate prereq)
  end

  belongs_to :from_task, class_name: "Task"
  belongs_to :to_task, class_name: "Task"

  validates :link_type, inclusion: { in: link_types }

  validate :cannot_link_to_self
  before_update { false }
  after_create :create_inverse, unless: :has_inverse?
  after_create :sync_dup_status
  after_destroy :destroy_inverses, if: :has_inverse?

  def self.viewable_task_links(user)
    task_links = TaskLink.all
    if user && !user.suspended?
      unless user.admin?
        tasks = tasks.where("created_by_user_id=? or assigned_user_id=? or viewable=true or (SELECT count(*) FROM view_user_tags WHERE view_user_tags.task_id = tasks.id AND view_user_tags.user_id = ?) > 0",
          user.id, user.id, user.id)
      end
    else
      task_links.where('')
      tasks = tasks.where(public_viewable: true)
    end
    tasks
  end

  def sync_dup_status
    return unless link_type == 'duplicate'
    to_task.update_attribute(:status_id, from_task.status_id)
  end

  private

  def cannot_link_to_self
    errors.add(:to_task, "can't link to self") if from_task_id == to_task_id
  end

  def create_inverse
    self.class.create(inverse_match_options)
  end

  def destroy_inverses
    inverses.destroy_all
  end

  def has_inverse?
    self.class.exists?(inverse_match_options) && link_type != 'prereq'
  end

  def inverses
    self.class.where(inverse_match_options)
  end

  def inverse_match_options
    { from_task_id: to_task_id, to_task_id: from_task_id, link_type: link_type }
  end
end
