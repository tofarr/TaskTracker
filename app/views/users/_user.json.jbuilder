json.extract! user, :id, :email, :name, :username, :password_digest, :verification_code, :admin, :suspended, :created_at, :updated_at
json.url user_url(user, format: :json)
