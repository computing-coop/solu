class Partner

  include Mongoid::Document
  include Mongoid::Slug
  
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
  field :logo_file_size, type: String
  field :logo_width, type: Integer
  field :logo_height, type: Integer
  field :logo_content_type, type: String
  
  field :coordinates, :type => Array
  
  embeds_many :photos, as: :photographic, cascade_callbacks: true
  accepts_nested_attributes_for :photos, allow_destroy: true
  
  has_and_belongs_to_many :activities_leading, class_name: 'Activity', inverse_of: :responsible_organisation
  
  
  slug :name
  
  index({ name: 1 }, { unique: true, drop_dups: true, name: "name_index" })
  
  mount_uploader :logo, ImageUploader
  
  include Geocoder::Model::Mongoid
  geocoded_by :full_address
  after_validation :geocode   
  
  def full_address
    [address1, address2, [postcode, city].compact.join(' '), country].compact.join(', ')
  end
  
end
