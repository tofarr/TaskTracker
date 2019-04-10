class TaskStatus < ApplicationRecord

  include Colored

  validates :title, presence: true
  has_one_attached :icon
  validate :only_one_default_apply

  has_and_belongs_to_many :next_statuses, class_name: "TaskStatus", join_table: :task_status_joins, foreign_key: :parent_id, association_foreign_key: :child_id
  has_and_belongs_to_many :task_searches, class_name: "TaskSearch"

  def only_one_default_apply
    return unless default_apply?
    task_status = TaskStatus.where(default_apply: true).first
    if task_status && (task_status.id != id)
      errors.add(:active, "Only one status (#{task_status.title}) may be applied by default")
    end
  end
end
