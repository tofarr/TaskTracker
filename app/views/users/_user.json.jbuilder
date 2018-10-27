json.extract! user, :id, :email, :name, :username, :verification_code, :admin, :suspended, :created_at, :updated_at
json.url user_url(user, format: :json)
