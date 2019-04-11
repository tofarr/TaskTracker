class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references :task, index: true, foreign_key: {on_delete: :cascade}, null: true
      t.references :user, index: true, foreign_key: {on_delete: :cascade}, null: false
      t.integer :created_by_user_id, null: true
      t.boolean :include_in_email, null: false, default: true
      t.boolean :seen, null: false, default: false
      t.text :message, null: false

      t.timestamps
    end
    add_foreign_key :notifications, :users, column: :created_by_user_id, on_delete: :cascade
  end
end
