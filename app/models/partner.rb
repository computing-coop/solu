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
  
  field :latitude, type: BigDecimal
  field :longitude, type: BigDecimal
  
  slug :name
  
  index({ name: 1 }, { unique: true, drop_dups: true, name: "name_index" })
  
  mount_uploader :logo, ImageUploader
  
end
