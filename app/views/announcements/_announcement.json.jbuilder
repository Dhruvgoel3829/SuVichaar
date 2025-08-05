json.extract! announcement, :id, :title, :content, :posted_on, :created_by, :created_at, :updated_at
json.url announcement_url(announcement, format: :json)
