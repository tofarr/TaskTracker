class CreateSprints < ActiveRecord::Migration[5.2]
  def change
    create_table :sprints do |t|
      t.string :title, :null => false
      t.datetime :start_at, index: {unique: false}, :null => false
      t.datetime :finish_at, index: {unique: false}, :null => false
      t.timestamps
    end

    create_join_table(:sprints, :tasks, on_delete: :cascade)
    create_join_table(:sprints, :users, on_delete: :cascade)

    add_column :task_statuses, :category, :string, :null => false, :limit => 50, :default => 'planning'
  end
end
