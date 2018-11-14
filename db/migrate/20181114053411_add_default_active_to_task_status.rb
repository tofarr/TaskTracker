class AddDefaultActiveToTaskStatus < ActiveRecord::Migration[5.2]
  def change
    add_column :task_statuses, :default_apply, :boolean, :null => false, :default => false
  end
end
