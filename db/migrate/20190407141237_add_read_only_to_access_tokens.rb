class AddReadOnlyToAccessTokens < ActiveRecord::Migration[5.2]
  def change
    add_column :access_tokens, :read_only, :boolean, :null => false, :default => false
  end
end
