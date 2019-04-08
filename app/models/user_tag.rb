class UserTag < ApplicationRecord
  validates :title, presence: true
  has_one_attached :icon
  has_many :user_tag_mutex
  has_many :mutex, through: :user_tag_mutex, dependent: :destroy

  has_and_belongs_to_many :created_task_searches, class_name: "TaskSearch", join_table: :task_searches_created_user_tags, foreign_key: :user_tag_id, association_foreign_key: :task_search_id
  has_and_belongs_to_many :assigned_task_searches, class_name: "TaskSearch", join_table: :task_searches_assigned_user_tags, foreign_key: :user_tag_id, association_foreign_key: :task_search_id

end
