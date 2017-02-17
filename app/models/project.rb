class Project
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  field :year_range, type: String
  field :name, type: String
  field :subtitle, type: String
  field :slug, type: String
  field :description, type: String
  field :image, type: String
  field :image_width, type: Integer
  field :image_height, type: Integer
  field :image_size, type: String
  field :image_content_type, type: String
  field :published, type: Boolean
  field :redirect_url, type: String
  field :ongoing, type: Boolean

  
  field :has_groups, type: Boolean
  field :custom_background_colour, type: String
  field :custom_background_image, type: String
  
  belongs_to :node, optional: true
  belongs_to :subsite, optional: true
  mount_uploader :image, ImageUploader
  mount_uploader :custom_background_image, BackgroundUploader
  
  slug :name, history: true
  include Imageable
  
  validates_uniqueness_of :name
  before_save :update_image_attributes
  
  has_many :posts
  has_many :pages 
  scope :published, ->() { where(published: true) }
  scope :ongoing, ->() { where(ongoing: true) }
  scope :older, -> () {where(:ongoing.in => ["", nil, false])}
end
