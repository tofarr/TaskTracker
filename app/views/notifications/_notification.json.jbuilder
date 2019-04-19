json.extract! notification, :id, :task_id, :user_id, :created_by_user_id, :seen, :include_in_email, :message, :created_at, :updated_at
json.url notification_url(notification, format: :json)
