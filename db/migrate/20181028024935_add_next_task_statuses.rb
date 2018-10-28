class AddNextTaskStatuses < ActiveRecord::Migration[5.2]
  def up
    create_table :task_status_joins, id: false do |t|
      t.integer :parent_id
      t.integer :child_id
    end
    add_foreign_key :task_status_joins, :task_statuses, column: :parent_id, on_delete: :cascade
    add_foreign_key :task_status_joins, :task_statuses, column: :child_id, on_delete: :cascade
    add_index(:task_status_joins, [:parent_id, :child_id], :unique => true)
  end

  def down
    drop_table :task_status_joins
  end
end
