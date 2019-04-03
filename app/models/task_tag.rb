class TaskTag < ApplicationRecord
  validates :title, presence: true
  has_one_attached :icon
  has_many :task_tag_mutex
  has_many :mutex, through: :task_tag_mutex, dependent: :destroy

  has_and_belongs_to_many :tasks, class_name: "Task", join_table: :task_tags_tasks, foreign_key: :task_tag_id, association_foreign_key: :task_id

end
