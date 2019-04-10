class AddIndexToActivityLog < ActiveRecord::Migration[5.2]
  def change
    add_index(:activity_logs, :model_id)
    add_index(:activity_logs, :model_type)
    add_index(:activity_logs, :created_at)
  end
end
