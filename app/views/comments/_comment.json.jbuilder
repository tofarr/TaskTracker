json.extract! comment, :id, :task_id, :text, :user_id, :created_at, :updated_at
json.url comment_url(comment, format: :json)
