class TaskTag < ApplicationRecord
  validates :title, presence: true
  has_one_attached :icon
  has_and_belongs_to_many :mutex, class_name: "TaskTag", join_table: :task_tags_mutex, foreign_key: :a_id, association_foreign_key: :b_id

  def self.check_mutex(tags)
    ret = tags.to_a
    tags.each do |tag|
      raise ApplicationController::NotAuthorized unless (tags & tag.mutex).empty?
    end
    ret
  end
end
