class AddActivityLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_logs do |t|
      t.integer :user_id
      t.string :username, null: false
      t.string :model_type, null: false, limit: 50 # Session|Task|User|UserTag|TaskTag|TaskStatus|TaskLink|Comment|Attachment
      t.integer :model_id, null: false
      t.string :action, null: false, limit: 50 # CREATE|UPDATE|DELETE
      t.text :new_value #json
      t.timestamps null: false
    end
  end
end
