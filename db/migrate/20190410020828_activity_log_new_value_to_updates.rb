class ActivityLogNewValueToUpdates < ActiveRecord::Migration[5.2]
  def change
    rename_column :activity_logs, :new_value, :updates
  end
end
