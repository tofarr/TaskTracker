class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :parent_id
      t.integer :assigned_user_id
      t.integer :created_by_user_id
      t.integer :status_id
      t.float :priority
      t.datetime :due_date
      t.integer :estimate
      t.integer :calculated_estimate

      t.timestamps
    end
    add_foreign_key :tasks, :tasks, column: :parent_id, on_delete: :nullify
    add_foreign_key :tasks, :users, column: :assigned_user_id, on_delete: :nullify
    add_foreign_key :tasks, :users, column: :created_by_user_id, on_delete: :nullify

  end
end
