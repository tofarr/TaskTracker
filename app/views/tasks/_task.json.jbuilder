json.extract! task, :id, :title, :description, :parent_id, :assigned_user_id, :created_user_id, :status_id, :tag_ids, :edit_user_tag_ids, :view_user_tag_ids, :priority, :due_date, :estimate, :calculated_estimate, :created_at, :updated_at
json.url task_url(task, format: :json)
