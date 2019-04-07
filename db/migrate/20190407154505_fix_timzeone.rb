class FixTimzeone < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :timezone, :string, :null => false, :default => "UTC", :limit => 100
    remove_column :users, :timzeone
  end
end
