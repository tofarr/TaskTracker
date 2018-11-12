json.extract! task_tag, :id, :title, :description, :created_at, :updated_at
json.url task_tag_url(task_tag, format: :json)
json.icon_url url_for(task_tag.icon) if task_tag.icon.attachment
