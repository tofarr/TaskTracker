# app/models/match.rb
class TaskLink < ApplicationRecord
  belongs_to :from_task, class_name: "Task"
  belongs_to :to_task, class_name: "Task"

  validates :link_type, inclusion: { in: %w(link duplicate prereq) }

  validate :cannot_link_to_self
  before_update { false }
  after_create :create_inverse, unless: :has_inverse?
  after_create :sync_dup_status
  after_destroy :destroy_inverses, if: :has_inverse?

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
