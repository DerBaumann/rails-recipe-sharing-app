json.extract! recipe, :id, :title, :prep_time_minutes, :instructions, :is_published, :created_at, :updated_at
json.url recipe_url(recipe, format: :json)
