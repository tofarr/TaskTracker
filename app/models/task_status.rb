class TaskStatus < ApplicationRecord

  validates :title, presence: true
  has_one_attached :icon

  has_and_belongs_to_many :next_statuses, class_name: "TaskStatus", join_table: :task_status_joins, foreign_key: :parent_id, association_foreign_key: :child_id
end
