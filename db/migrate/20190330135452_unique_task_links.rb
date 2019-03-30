class UniqueTaskLinks < ActiveRecord::Migration[5.2]
  def change
    add_index :task_links, [:from_task_id, :to_task_id], unique: true
  end
end
