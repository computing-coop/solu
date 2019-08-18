class Partner

  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps

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
  field :is_funder, type:  Mongoid::Boolean
  field :is_general, type:  Mongoid::Boolean
  field :start_year, type: Integer
  field :end_year, type: Integer

  embeds_many :photos, as: :photographic, cascade_callbacks: true
  accepts_nested_attributes_for :photos, allow_destroy: true
  validates :name, presence: true, uniqueness: true
  validates :country, presence: true, length: {minimum: 2, maximum: 2}
  validate :end_after_start
  validate :years_are_real

  has_and_belongs_to_many :activities_leading, class_name: 'Activity', inverse_of: :responsible_organisation

  has_and_belongs_to_many :projects
  accepts_nested_attributes_for :projects, reject_if: lambda {|x| x.blank?}


  belongs_to :node, optional: true

  slug :name

  scope :by_node, ->(x) { where(node: x)}
  scope :funders, ->() { where(is_funder: true) }

  index({ name: 1 }, { unique: true, drop_dups: true, name: "name_index" })

  mount_uploader :logo, LogoUploader
  mount_uploader :hmlogo, ImageUploader

  before_save :get_logo_metadatas

  include Geocoder::Model::Mongoid
  geocoded_by :full_address
  after_validation :geocode if Rails.env.production?


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

  protected

  def end_after_start
    return if end_year.blank? || start_year.blank?
    errors.add(:end_year, "must be after starting year") if end_year < start_year
  end

  def years_are_real
    return if end_year.blank? && start_year.blank?
    errors.add(:end_year, "Year must be between 2000 and 2200") if end_year && (end_year < 2000 || end_year > 2200)
    errors.add(:start_year, "Year must be between 2000 and 2200") if start_year && (start_year < 2000 || start_year > 2200)
  end
end
