json.extract! access_token, :id, :title, :token, :expires_at, :suspended, :created_at, :updated_at
json.url access_token_url(access_token, format: :json)
