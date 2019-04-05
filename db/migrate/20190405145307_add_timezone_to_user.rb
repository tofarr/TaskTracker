class AddTimezoneToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :timzeone, :string, :null => false, :default => "UTC", :limit => 100
  end
end
