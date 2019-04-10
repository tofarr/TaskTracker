json.extract! activity_log, :id, :username, :model_type, :model_id, :action, :updates, :created_at
json.url activity_log_url(activity_log, format: :json)
