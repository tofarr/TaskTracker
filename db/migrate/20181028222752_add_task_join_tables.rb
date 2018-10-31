class AddTaskJoinTables < ActiveRecord::Migration[5.2]

  def up

    #add admin and default to task tag
    create_join_table :tasks, :task_tags do |t|
      t.index [:task_id, :task_tag_id]
      t.index [:task_tag_id, :task_id]
    end

    create_table :view_user_tags, id: false do |t|
      t.integer :task_id
      t.integer :user_tag_id
    end

    add_foreign_key :view_user_tags, :tasks, column: :task_id, on_delete: :cascade
    add_foreign_key :view_user_tags, :tasks, column: :user_tag_id, on_delete: :cascade
    add_index(:view_user_tags, [:task_id, :user_tag_id], :unique => true)

    create_table :edit_user_tags, id: false do |t|
      t.integer :task_id
      t.integer :user_tag_id
    end

    add_foreign_key :edit_user_tags, :tasks, column: :task_id, on_delete: :cascade
    add_foreign_key :edit_user_tags, :tasks, column: :user_tag_id, on_delete: :cascade
    add_index(:edit_user_tags, [:task_id, :user_tag_id], :unique => true)
  end

  def down
    drop_table :tasks_task_tags
    drop_table :view_user_tags
    drop_table :edit_user_tags
  end

end
