class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.string :title
      t.text :description
      t.integer :user_id, null: false, index: {unique: false}
      t.integer :task_id, null: false, index: {unique: false}

      t.timestamps
    end
  end
end
