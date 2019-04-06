class CreateAccessTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :access_tokens do |t|
        t.integer :user_id, null: false
        t.string :title, index: {unique: false}
        t.string :token, index: {unique: true}
        t.datetime :expires_at, index: {unique: false}
        t.boolean :suspended, null: false, default: false
        t.timestamps
    end
    add_foreign_key :access_tokens, :users, column: :user_id, on_delete: :cascade
  end
end
