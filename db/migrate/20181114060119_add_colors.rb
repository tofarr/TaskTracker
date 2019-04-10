class AddColors < ActiveRecord::Migration[5.2]
  def change
    add_column :task_tags, :color, :string, :null => false, :limit => 8
    add_column :user_tags, :color, :string, :null => false, :limit => 8
    add_column :task_statuses, :color, :string, :null => false, :limit => 8
  end
end
