class RemoveVerificationCode < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :verification_code
  end
end
