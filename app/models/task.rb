class Task < ApplicationRecord
  belongs_to :parent, :foreign_key => :parent_id, :class_name => "Task", :optional => true
  has_many :children, :foreign_key => :parent_id, :class_name => "Task"
  belongs_to :assigned_user, :foreign_key => :assigned_user_id, :class_name => "User", :required => false
  belongs_to :created_user, :foreign_key => :created_user_id, :class_name => "User"
  belongs_to :status, :foreign_key => :status_id, :class_name => "TaskStatus"
  has_and_belongs_to_many :tags, class_name: "TaskTag", join_table: :task_tags_tasks, foreign_key: :task_id, association_foreign_key: :task_tag_id
  validate :check_tag_mutex
  validate :editable_viewable

  has_many :from_links, :foreign_key => :to_task_id, :class_name => "TaskLink", :dependent => :destroy
  has_many :to_links, :foreign_key => :from_task_id, :class_name => "TaskLink", :dependent => :destroy
  validate :validate_prereqs
  after_update :sync_dup_status
  after_create :sync_dup_status
  before_save :update_estimate
  after_save :update_parent_estimate

  validates :title, presence: true

  has_many :comments, :dependent => :destroy
  has_many :attachments, :dependent => :destroy

  def self.editable_tasks(user)
    tasks = Task.all
    if user && !user.suspended?
      unless user.admin?
        tasks = tasks.where("created_user_id=? or assigned_user_id=? or editable=true",
          user.id, user.id)
      end
    else
      tasks = tasks.where(public_viewable: true)
    end
    tasks
  end

  def self.viewable_tasks(user)
    tasks = Task.all
    if user && !user.suspended?
      unless user.admin?
        tasks = tasks.where("created_user_id=? or assigned_user_id=? or viewable=true",
          user.id, user.id)
      end
    else
      tasks = tasks.where(public_viewable: true)
    end
    tasks
  end

  def identifier
    "(#{id}) #{title}"
  end

  def viewable_by?(user)
    return false unless user
    viewable || owned_by?(user) || (view_user_tags & user.tags).any?
  end

  def editable_by?(user)
    return false unless user
    editable || owned_by?(user) || (edit_user_tags & user.tags).any?
  end

  def owned_by?(user)
    return false unless user
    user.admin || user.id == created_by_id || user.id == assigned_user_id
  end


  def editable_viewable
    if !viewable
      if editable
        errors.add(:viewable, "Must be viewable to be editable!")
      end
      if commentable
        errors.add(:viewable, "Must be viewable to be commentable!")
      end
      if public_viewable
        errors.add(:viewable, "Must be viewable to be publicly viewable!")
      end
    end
  end

  def check_tag_mutex
    tags.each do |tag|
      errors.add(:tags, "Must be viewable to be editable!") unless (tags & tag.mutex).empty?
    end
  end

  def update_estimate
    if estimate
      self.calculated_estimate = estimate
    else
      self.calculated_estimate = children.inject(0) {|estimate, task| estimate + (task.calculated_estimate || 0) }
    end
  end

  private

  def sync_dup_status
    if self.status_id_changed?
      to_links.where(link_type: 'duplicate').each do |link|
        link.to_task.update_attribute(status_id: status_id)
      end
    end
  end

  def validate_prereqs
    if status.present? && !status.requires_action
      from_links.where(link_type: 'prereq').select do |link|
        errors.add(:from_links, "Prerequisites must be complete!") if link.from_task.status.requires_action
      end
    end
  end

  def update_parent_estimate
    diff = (calculated_estimate || 0) - (calculated_estimate_was || 0)
    if parent && diff != 0
      parent.update_attribute(:calculated_estimate, parent.calculated_estimate + diff)
    end
  end

end
