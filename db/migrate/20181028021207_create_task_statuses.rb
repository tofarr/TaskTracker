class CreateTaskStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :task_statuses do |t|
      t.string :title, null: false, unique: true
      t.text :description
      t.boolean :requires_action, null: false

      t.timestamps
    end
  end
end
