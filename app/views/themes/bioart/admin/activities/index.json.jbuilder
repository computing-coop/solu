json.array!(@activities) do |activity|
  json.extract! activity, :id, :name, :activity_type, :description, :start_at, :end_at
  json.url activity_url(activity, format: :json)
end
