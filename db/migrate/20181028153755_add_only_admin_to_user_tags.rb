class AddOnlyAdminToUserTags < ActiveRecord::Migration[5.2]

  def up
    add_column :user_tags, :only_admin_can_apply, :boolean, :null => false, :default => false
    add_column :user_tags, :default_apply, :boolean, :null => false, :default => false

    create_table :user_tags_mutex, id: false do |t|
      t.integer :a_id
      t.integer :b_id
    end

    add_foreign_key :user_tags_mutex, :user_tags, column: :a_id, on_delete: :cascade
    add_foreign_key :user_tags_mutex, :user_tags, column: :b_id, on_delete: :cascade
    add_index(:user_tags_mutex, [:a_id, :b_id], :unique => true)
  end

  def down
    remove_column :user_tags, :only_admin_can_apply
    remove_column :user_tags, :default_apply
    drop_table :user_tags_mutex
  end
end
