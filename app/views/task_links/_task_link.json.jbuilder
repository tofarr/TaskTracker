json.extract! task_link, :id, :link_type, :from_task_id, :to_task_id, :created_at, :updated_at
json.url task_link_url(task_link, format: :json)
