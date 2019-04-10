class TaskSearch < ApplicationRecord

  def self.sort_orders
     [''] + %w(priority title created_at updated_at)
  end

  belongs_to :user
  has_and_belongs_to_many :task_tags, class_name: "TaskTag"
  #ADD tHE OTHER END OF THESE
  has_and_belongs_to_many :created_user_tags, class_name: "UserTag", join_table: :task_searches_created_user_tags, foreign_key: :task_search_id, association_foreign_key: :user_tag_id
  has_and_belongs_to_many :assigned_user_tags, class_name: "UserTag", join_table: :task_searches_assigned_user_tags, foreign_key: :task_search_id, association_foreign_key: :user_tag_id

  has_and_belongs_to_many :created_users, class_name: "User", join_table: :task_searches_created_users, foreign_key: :task_search_id, association_foreign_key: :user_id
  has_and_belongs_to_many :assigned_users, class_name: "User", join_table: :task_searches_assigned_users, foreign_key: :task_search_id, association_foreign_key: :user_id

  has_and_belongs_to_many :task_statuses, class_name: "TaskStatus"

  validates :title, presence: true
  validates :sort_order, inclusion: { in: sort_orders }, :allow_nil => true

  def self.editable_searches(user)
    if user && !user.suspended?
      return TaskSearch.all if user.admin?
      return TaskSearch.where(user_id: user.id)
    end
    return TaskSearch.none
  end

  def self.viewable_searches(user)
    if user && !user.suspended?
      return TaskSearch.all if user.admin?
      return TaskSearch.where("user_id=? or public=true", user.id)
    end
    return TaskSearch.where(public: true)
  end

  def viewable_by?(user)
    user && (public || editable_by?(user))
  end

  def editable_by?(user)
    user && user.id == user_id
  end

  def search(user)
    tasks = Task.viewable_tasks(user)
    tasks = tasks.where("title like ? or description like ?", "%#{query}%", "%#{query}%") unless query.blank?

    tasks = tasks.where(task_tag_ids: task_tag_ids) unless task_tag_ids.blank?

    tasks = tasks.where(created_user_tag_ids: created_user_tag_ids) unless created_user_tag_ids.blank?
    tasks = tasks.where(assigned_user_tag_ids: assigned_user_tag_ids) unless assigned_user_tag_ids.blank?

    tasks = tasks.where(created_user_id: created_user_ids) unless created_user_ids.blank?
    tasks = tasks.where(assigned_user_id: assigned_user_ids) unless assigned_user_ids.blank?

    tasks = tasks.where(task_status_ids: task_status_ids) unless task_status_ids.blank?

    if sort_order.present?
      order = {}
      order[sort_order.to_sym] = descending ? :desc : :asc
      tasks = tasks.send(:order, order)
    end

    tasks
  end

  def default_search?
    return query.blank? &&
      task_tags.empty? &&
      created_user_tags.empty? &&
      assigned_user_tags.empty? &&
      created_users.empty? &&
      assigned_users.empty? &&
      task_statuses.empty? &&
      sort_order.blank?
  end

end
