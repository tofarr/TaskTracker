json.extract! task, :id, :title, :identifier, :description, :parent_id, :assigned_user_id, :created_user_id, :status_id, :tag_ids, :priority, :due_date, :estimate, :calculated_estimate, :viewable, :editable, :commentable, :public_viewable, :created_at, :updated_at
json.url task_url(task, format: :json)
