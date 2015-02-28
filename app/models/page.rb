class Page
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  include Imageable
  validates_uniqueness_of :title
  before_save :update_image_attributes
  
  
  field :title, type: String
  field :body, type: String
  field :image, type: String
  
  field :image_size, type: Integer
  field :image_width, type: Integer
  field :image_height, type: Integer
  field :image_content_type, type: String
  
  field :published, type: Boolean
  
  mount_uploader :image, ImageUploader
    
  slug :title
  
  embeds_many :photos, as: :photographic, cascade_callbacks: true
  accepts_nested_attributes_for :photos, allow_destroy: true
  
end

