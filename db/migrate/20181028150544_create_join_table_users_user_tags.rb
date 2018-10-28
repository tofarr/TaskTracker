class CreateJoinTableUsersUserTags < ActiveRecord::Migration[5.2]
  def change
    create_join_table :users, :user_tags do |t|
      t.index [:user_id, :user_tag_id]
      t.index [:user_tag_id, :user_id]
    end
  end
end
