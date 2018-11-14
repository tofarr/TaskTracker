class TaskTagReciprocatedMutex < ActiveRecord::Migration[5.2]
  def change
    drop_table :task_tags_mutex

    create_table :task_tag_mutexes do |t|
      t.references :task_tag, index: true, foreign_key: true
      t.references :mutex, index: true

      t.timestamps null: false
    end

    add_foreign_key :task_tag_mutexes, :task_tags, column: :mutex_id
    add_index :task_tag_mutexes, [:task_tag_id, :mutex_id], unique: true
  end
end
