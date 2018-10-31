class Task < ApplicationRecord
  belongs_to :parent, :foreign_key => :parent_id
  has_many :children, :foreign_key => :parent_id, :class_name => "Task"
  belongs_to :assigned_user, :foreign_key => :assigned_user_id, :class_name => "User"
  belongs_to :created_user, :foreign_key => :created_user_id, :class_name => "User"
  belongs_to :status, :foreign_key => :status_id, :class_name => "TaskStatus"
  has_and_belongs_to_many :tags, class_name: "TaskTag", join_table: :task_tags_tasks, foreign_key: :task_id, association_foreign_key: :task_tag_id
  has_and_belongs_to_many :edit_user_tags, class_name: "UserTag", join_table: :view_user_tags, foreign_key: :task_id, association_foreign_key: :user_tag_id
  has_and_belongs_to_many :view_user_tags, class_name: "UserTag", join_table: :edit_user_tags, foreign_key: :task_id, association_foreign_key: :user_tag_id
end
