class Page
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  include Mongoid::Tree
  include Mongoid::Tree::Ordering
  include Imageable
  include Mongoid::Taggable

  
  field :title, type: String
  field :body, type: String
  field :image, type: String
  field :background, type: String
  
  field :excerpt, type: String
  field :is_project_overview, type: Mongoid::Boolean
  field :hide_from_menu, type: Mongoid::Boolean
  
  field :image_size, type: Integer
  field :image_width, type: Integer
  field :image_height, type: Integer
  field :image_content_type, type: String

  field :background_size, type: Integer
  field :background_width, type: Integer
  field :background_height, type: Integer
  field :background_content_type, type: String
    
  field :published, type: Boolean
  belongs_to :activity, optional: true
  belongs_to :project, optional: true

  field :wordpress_scope, type: String
  field :wordpress_author, type: String
  field :wordpress_id, type: Integer
  
  field :split_on_h3, type: Mongoid::Boolean
  field :two_columns, type: Mongoid::Boolean
  
  mount_uploader :image, ImageUploader
  mount_uploader :background, BackgroundUploader
  
  belongs_to :subsite, optional: true
  belongs_to :node, inverse_of: :pages
  
  has_one :postcategory
  
  
  slug :title, scope: [:node, :project]
    
  embeds_many :photos, as: :photographic, cascade_callbacks: true
  embeds_many :soundfiles, as: :soundable, cascade_callbacks: true
  embeds_many :videos, as: :videographic, cascade_callbacks: true
  
  accepts_nested_attributes_for :soundfiles, allow_destroy: true
  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true
  
  scope :by_node, ->(node) { where(node: node)}
  scope :by_project,  ->(x) {where(project: x)}
  
  validates_presence_of :title, :body
  validates_uniqueness_of :title, scope: [:node, :project]
  
  before_save :update_image_attributes
  
  
  def all_images
    o = photos.flatten.compact.uniq
    # unless activity.nil?
    #   o += activity.works.map{|x| x.photos}.flatten.compact.uniq
    # end
    o.flatten.compact.uniq
  end
  
  def headings
    Nokogiri::HTML(self.body).search('a[name]').map{|x| [x['name'], x.text] }.delete_if{|x| x.first.blank? }
  end
  
  def index_image
    image? ? "background: #d8d9db url(#{image.url(:box)}) center/cover no-repeat;" :
    (project? ? project.index_image : 
      "background: #d8d9db url(/assets/bioart/images/placeholder.png) center/cover no-repeat" )
  end
  
  def name
    title
  end
  
  def description
    body
  end

end

