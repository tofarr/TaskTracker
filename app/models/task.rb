class Task < ApplicationRecord
  belongs_to :parent, :foreign_key => :parent_id, :optional => true
  has_many :children, :foreign_key => :parent_id, :class_name => "Task"
  belongs_to :assigned_user, :foreign_key => :assigned_user_id, :class_name => "User", :required => false
  belongs_to :created_user, :foreign_key => :created_user_id, :class_name => "User"
  belongs_to :status, :foreign_key => :status_id, :class_name => "TaskStatus"
  has_and_belongs_to_many :tags, class_name: "TaskTag", join_table: :task_tags_tasks, foreign_key: :task_id, association_foreign_key: :task_tag_id
  validate :editable_viewable

  has_many :from_links, :foreign_key => :to_task_id, :class_name => "TaskLink"
  has_many :to_links, :foreign_key => :from_task_id, :class_name => "TaskLink"
  validate :validate_prereqs
  after_update :sync_dup_status
  after_create :sync_dup_status

  has_many :comments
  has_many :attachments

  def self.editable_tasks(user)
    tasks = Task.all
    if user && !user.suspended?
      unless user.admin?
        tasks = tasks.where("created_user_id=? or assigned_user_id=? or editable=true",
          user.id, user.id, user.id)
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
          user.id, user.id, user.id)
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
    viewable || owned_by?(user) || (view_user_tags & user.tags).any?
  end

  def editable_by?(user)
    editable || owned_by?(user) || (edit_user_tags & user.tags).any?
  end

  def owned_by?(user)
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

  private

  def sync_dup_status
    if self.status_id_changed?
      to_links.where(link_type: 'duplicate').each do |link|
        link.to_task.update_attribute(status_id: status_id)
      end
    end
  end

  def validate_prereqs
    unless status.requires_action
      from_links.where(link_type: 'prereq').select do |link|
        errors.add(:from_links, "Prerequisites must be complete!") if link.from_task.status.requires_action
      end
    end
  end

end
