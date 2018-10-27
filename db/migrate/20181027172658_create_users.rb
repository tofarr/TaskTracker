class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :username
      t.string :password_digest
      t.string :verification_code
      t.boolean :admin
      t.boolean :suspended

      t.timestamps
    end
  end
end
