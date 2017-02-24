class Partner

  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  
  validates_uniqueness_of :name

  field :name, type: String
  field :website, type: String
  field :address1, type: String
  field :address2, type: String
  field :city, type: String
  field :country, type: String
  field :postcode, type: String
  field :description, type: String
  field :logo, type: String
  field :logo_size, type: String
  field :logo_width, type: Integer
  field :logo_height, type: Integer
  field :logo_content_type, type: String
  field :hmlogo, type: String
  field :hmlogo_size, type: String
  field :hmlogo_width, type: Integer
  field :hmlogo_height, type: Integer
  field :hmlogo_content_type, type: String
  field :css_colour, type: String
  field :coordinates, :type => Array
  
  embeds_many :photos, as: :photographic, cascade_callbacks: true
  accepts_nested_attributes_for :photos, allow_destroy: true
  

  
  has_and_belongs_to_many :activities_leading, class_name: 'Activity', inverse_of: :responsible_organisation
  
  has_and_belongs_to_many :projects
  accepts_nested_attributes_for :projects, reject_if: lambda {|x| x.blank?}

  
  belongs_to :node
  
  slug :name
  
  scope :by_node, ->(x) { where(node: x)}
  
  index({ name: 1 }, { unique: true, drop_dups: true, name: "name_index" })
  
  mount_uploader :logo, ImageUploader
  mount_uploader :hmlogo, ImageUploader
  
  before_save :get_logo_metadatas
  
  include Geocoder::Model::Mongoid
  geocoded_by :full_address
  after_validation :geocode   
  
  def full_address
    [address1, address2, [postcode, city].compact.join(' '), country].compact.join(', ')
  end
  
  def get_logo_metadatas

    if logo.present? && logo_changed?
      if logo.file.exists?
        self.logo_content_type = logo.file.content_type
        self.logo_size = logo.file.size
        self.logo_width, self.logo_height = `identify -format "%wx%h" #{logo.file.path}`.split(/x/)
      end
    end

    if hmlogo.present? && hmlogo_changed?
      if hmlogo.file.exists?
        self.hmlogo_content_type = hmlogo.file.content_type
        self.hmlogo_size = hmlogo.file.size
        self.hmlogo_width, self.hmlogo_height = `identify -format "%wx%h" #{hmlogo.file.path}`.split(/x/)
      end
    end
    
  end
  
end
