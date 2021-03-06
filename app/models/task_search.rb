class TaskSearch < ApplicationRecord

  def self.permitted_sort_orders
     [''] + %w(priority title created_at updated_at)
  end

  belongs_to :user
  has_and_belongs_to_many :task_tags, class_name: "TaskTag"
  #ADD tHE OTHER END OF THESE
  has_and_belongs_to_many :created_by_user_tags, class_name: "UserTag", join_table: :task_searches_created_by_user_tags, foreign_key: :task_search_id, association_foreign_key: :user_tag_id
  has_and_belongs_to_many :assigned_user_tags, class_name: "UserTag", join_table: :task_searches_assigned_user_tags, foreign_key: :task_search_id, association_foreign_key: :user_tag_id

  has_and_belongs_to_many :created_by_users, class_name: "User", join_table: :task_searches_created_by_users, foreign_key: :task_search_id, association_foreign_key: :user_id
  has_and_belongs_to_many :assigned_users, class_name: "User", join_table: :task_searches_assigned_users, foreign_key: :task_search_id, association_foreign_key: :user_id

  has_and_belongs_to_many :task_statuses, class_name: "TaskStatus"

  validates :title, presence: true
  validates :sort_order, inclusion: { in: permitted_sort_orders }, :allow_nil => true

  def self.get_search(user, params)
    id = params.fetch(:task_search, {})[:id]
    task_search = id ? TaskSearch.viewable_searches(user).find(id) : TaskSearch.new
    task_search.assign_attributes(TaskSearchesController.task_search_params(params))
    task_search.user = user
    if task_search.task_statuses.blank?
      task_search.task_statuses = TaskStatus.where(category: [:planning, :in_progress])
    end
    task_search
  end

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
    return false if user.suspended?
    user && (public || editable_by?(user))
  end

  def editable_by?(user)
    return false if user.suspended?
    user && user.id == user_id
  end

  def search(user, force_order = false)
    tasks = Task.viewable_tasks(user)
    tasks = tasks.where("title like ? or description like ?", "%#{query}%", "%#{query}%") unless query.blank?

    tasks = tasks.where(task_tag_ids: task_tag_ids) unless task_tag_ids.blank?

    tasks = tasks.where(created_by_user_tag_ids: created_by_user_tag_ids) unless created_by_user_tag_ids.blank?
    tasks = tasks.where(assigned_user_tag_ids: assigned_user_tag_ids) unless assigned_user_tag_ids.blank?

    tasks = tasks.where(created_by_user_id: created_by_user_ids) unless created_by_user_ids.blank?
    tasks = tasks.where(assigned_user_id: assigned_user_ids) unless assigned_user_ids.blank?

    tasks = tasks.where(status_id: task_status_ids) unless task_status_ids.blank?

    if sort_order.present? && permitted_sort_orders.include?(sort_order)
      order = {}
      order[sort_order.to_sym] = descending ? :desc : :asc
      tasks = tasks.send(:order, order)
    elsif force_order
      tasks = tasks.order(priority: :desc, updated_at: :desc)
    end

    tasks
  end

  def default_search?
    return query.blank? &&
      task_tags.empty? &&
      created_by_user_tags.empty? &&
      assigned_user_tags.empty? &&
      created_by_users.empty? &&
      assigned_users.empty? &&
      #task_statuses.empty? &&
      sort_order.blank?
  end

end
