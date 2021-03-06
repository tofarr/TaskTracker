json.extract! task_status, :id, :title, :description, :requires_action, :default_apply, :color, :next_status_ids, :category, :created_at, :updated_at
json.icon_url url_for(task_status.icon) if task_status.icon.attachment
json.url task_status_url(task_status, format: :json)
json.icon_url url_for(task_status.icon) if task_status.icon.attachment
