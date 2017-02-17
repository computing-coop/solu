class Photo
  include Mongoid::Document
  field :image, type: String
  field :image_size, type: Integer
  field :image_width, type: Integer
  field :image_height, type: Integer
  field :image_content_type, type: String
  field :wordpress_id, type: Integer
  
  mount_uploader :image, ImageUploader
  include Imageable 
  before_save :update_image_attributes
  
  embedded_in :photographic, polymorphic: true
  
end
