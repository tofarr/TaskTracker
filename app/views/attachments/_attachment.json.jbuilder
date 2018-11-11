json.extract! attachment, :id, :title, :description, :user_id, :created_at, :updated_at
json.url attachment_url(attachment, format: :json)
