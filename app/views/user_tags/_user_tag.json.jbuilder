json.extract! user_tag, :id, :title, :description, :created_at, :updated_at
json.url user_tag_url(user_tag, format: :json)
