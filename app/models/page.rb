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
  belongs_to :activity
  
  mount_uploader :image, ImageUploader
    
  belongs_to :subsite

  slug :title, history: true
    
  embeds_many :photos, as: :photographic, cascade_callbacks: true
  accepts_nested_attributes_for :photos, allow_destroy: true
  
  def all_images
    o = photos.flatten.compact.uniq
    unless activity.nil?
      o += activity.works.map{|x| x.photos}.flatten.compact.uniq
    end
    o.flatten.compact.uniq
  end
  
  def headings
    Nokogiri::HTML(self.body).search('a[name]').map{|x| [x['name'], x.text] }.delete_if{|x| x.first.blank? }
  end
  
end

