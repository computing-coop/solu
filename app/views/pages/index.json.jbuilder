json.array!(@pages) do |page|
  json.extract! page, :id, :title, :body, :image, :image_file_size, :image_width, :image_height, :image_content_type
  json.url page_url(page, format: :json)
end
