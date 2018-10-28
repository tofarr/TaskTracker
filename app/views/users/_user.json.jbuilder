json.extract! user, :id, :email, :name, :username, :admin, :suspended, :tag_ids, :created_at, :updated_at
json.verification_code user.verification_code if @current_user.admin?
json.url user_url(user, format: :json)
