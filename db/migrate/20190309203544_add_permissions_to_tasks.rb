class AddPermissionsToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :viewable, :boolean, :null => false, :default => true
    add_column :tasks, :editable, :boolean, :null => false, :default => true
    add_column :tasks, :commentable, :boolean, :null => false, :default => true
    add_column :tasks, :public_viewable, :boolean, :null => false, :default => false
  end
end
