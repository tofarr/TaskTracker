json.extract! task, :id, :title, :description, :parent_id, :user_id, :created_by, :status_id, :priority, :calculated_updated_at, :due_date, :estimate, :created_at, :updated_at
json.url task_url(task, format: :json)
