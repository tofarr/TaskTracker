class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.integer :task_id, null: false, index: {unique: false}
      t.integer :user_id, null: false, index: {unique: false}
      t.string :text, null: false
      
      t.timestamps
    end
  end
end
