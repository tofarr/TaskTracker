json.extract! attachment, :id, :title, :description, :user_id, :created_at, :updated_at
json.url attachment_url(attachment, format: :json)
json.data_url url_for(attachment.data)
