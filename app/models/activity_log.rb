class ActivityLog < ApplicationRecord

  def self.action_types
     %w(CREATE UPDATE DESTROY)
  end

  validates :username, presence: true
  validates :model_type, presence: true
  validates :model_id, presence: true
  validates :action, inclusion: { in: action_types }

  def updates
    JSON.parse(read_attribute(:updates))
  end

  def updates=(value)
    write_attribute(:updates, value&.to_json)
  end
end
