class UserTagReciprocatedMutex < ActiveRecord::Migration[5.2]
  def change
    drop_table :user_tags_mutex

    create_table :user_tag_mutexes do |t|
      t.references :user_tag, index: true, foreign_key: true
      t.references :mutex, index: true

      t.timestamps null: false
    end

    add_foreign_key :user_tag_mutexes, :user_tags, column: :mutex_id
    add_index :user_tag_mutexes, [:user_tag_id, :mutex_id], unique: true
  end
end
