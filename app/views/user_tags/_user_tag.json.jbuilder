json.extract! user_tag, :id, :title, :description, :color, :created_at, :updated_at
json.url user_tag_url(user_tag, format: :json)
json.icon_url url_for(user_tag.icon) if user_tag.icon.attachment
