class CreateBatchJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :batch_jobs do |t|
      t.integer :user_id
      t.string :type, limit: 50
      t.boolean :done, default: false, null: false, index: {unique: false}
      t.timestamps
    end
  end
end
