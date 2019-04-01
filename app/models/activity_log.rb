class ActivityLog < ApplicationRecord

  def self.action_types
     %w(CREATE UPDATE DESTROY)
  end

  validates :username, presence: true
  validates :model_type, presence: true
  validates :model_id, presence: true
  validates :action, inclusion: { in: action_types }

  def new_value
    JSON.parse(read_attribute(:new_value))
  end

  def new_value=(value)
    write_attribute(:new_value, value&.to_json)
  end
end
