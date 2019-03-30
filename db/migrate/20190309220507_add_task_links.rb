class AddTaskLinks < ActiveRecord::Migration[5.2]
  def change

    create_table :task_links do |t|
      t.integer :from_task_id, null: false, index: {unique: false}
      t.integer :to_task_id, null: false, index: {unique: false}
      t.string :link_type, limit: 50, index: {unique: false}
      t.timestamps null: false
    end
    add_foreign_key :task_links, :tasks, column: :a_task_id, on_delete: :cascade
    add_foreign_key :task_prereqs, :tasks, column: :b_task_id, on_delete: :cascade
  end
end
