class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email, index: {unique: false}
      t.string :name
      t.string :username, null: false, index: {unique: true}
      t.string :password_digest
      t.string :verification_code
      t.boolean :admin, null: false, default: false
      t.boolean :suspended, null: false, default: false

      t.timestamps
    end
  end
end
