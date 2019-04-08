json.extract! task_search, :id, :query, :created_at, :updated_at
json.url task_search_url(task_search, format: :json)
