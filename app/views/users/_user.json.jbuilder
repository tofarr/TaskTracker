json.extract! user, :id, :email, :name, :username, :admin, :suspended, :tag_ids, :created_at, :updated_at
json.url user_url(user, format: :json)
json.avatar_url url_for(user.avatar) if user.avatar.attachment
if user.password_digest.blank? && (access_token = user.active_access_tokens.first)
  json.access_link edit_user_path(user, :token => access_token.token)
end
