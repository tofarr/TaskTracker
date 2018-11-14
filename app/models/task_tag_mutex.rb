# app/models/match.rb
class TaskTagMutex < ApplicationRecord
  belongs_to :task_tag
  belongs_to :mutex, class_name: "TaskTag"

  after_create :create_inverse, unless: :has_inverse?
  after_destroy :destroy_inverses, if: :has_inverse?

  def create_inverse
    self.class.create(inverse_match_options)
  end

  def destroy_inverses
    inverses.destroy_all
  end

  def has_inverse?
    self.class.exists?(inverse_match_options)
  end

  def inverses
    self.class.where(inverse_match_options)
  end

  def inverse_match_options
    { task_tag_id: mutex_id, mutex_id: task_tag_id }
  end
end
