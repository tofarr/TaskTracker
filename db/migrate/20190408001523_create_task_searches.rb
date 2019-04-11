class CreateTaskSearches < ActiveRecord::Migration[5.2]
  def change
    create_table :task_searches do |t|
      t.string :query
      t.string :title, :null => false
      t.integer :user_id, :null => false
      t.boolean :public, :null => false, :default => false
      t.string :sort_order
      t.boolean :descending, :null => false, :default => false
      t.timestamps
    end
    add_foreign_key :task_searches, :users, column: :user_id, on_delete: :cascade

    create_join_table(:task_searches, :task_tags, on_delete: :cascade)
    create_join_table(:task_searches, :user_tags, table_name: "task_searches_created_by_user_tags", on_delete: :cascade)
    create_join_table(:task_searches, :user_tags, table_name: "task_searches_assigned_user_tags", on_delete: :cascade)
    create_join_table(:task_searches, :users, table_name: "task_searches_created_by_users", on_delete: :cascade)
    create_join_table(:task_searches, :users, table_name: "task_searches_assigned_users", on_delete: :cascade)
    create_join_table(:task_searches, :task_statuses, on_delete: :cascade)

    add_index(:task_searches_tags, [:task_search_id, :task_tag_id], :unique => true, :name => 'idx_task_searches_tags')
    add_index(:task_searches_created_by_user_tags, [:task_search_id, :user_tag_id], :unique => true, :name => 'idx_task_searches_created_by_user_tags')
    add_index(:task_searches_assigned_user_tags, [:task_search_id, :user_tag_id], :unique => true, :name => 'idx_task_searches_assigned_user_tags')
    add_index(:task_searches_created_by_users, [:task_search_id, :user_id], :unique => true, :name => 'idx_task_searches_created_by_users')
    add_index(:task_searches_assigned_users, [:task_search_id, :user_id], :unique => true, :name => 'idx_task_searches_assigned_users')
    add_index(:task_searches_statuses, [:task_search_id, :task_status_id], :unique => true, :name => 'idx_task_searches_statuses')

  end
end
