class CreateTaskTags < ActiveRecord::Migration[5.2]
  def change
    create_table :task_tags do |t|
      t.string :title, null: false, unique: true
      t.text :description

      t.timestamps
    end
  end
end
