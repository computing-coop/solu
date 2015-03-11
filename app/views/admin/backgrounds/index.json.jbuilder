json.array!(@backgrounds) do |background|
  json.extract! background, :id, :regular, :regular_size, :regular_height, :regular_width, :regular_content_type, :mobile, :mobile_size, :mobile_height, :mobile_width, :mobile_content_type, :active
  json.url background_url(background, format: :json)
end
