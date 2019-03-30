class RemoveUserTagPermissions < ActiveRecord::Migration[5.2]
  def up
    drop_table :view_user_tags
    drop_table :edit_user_tags
  end
end
