class Activity
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  field :name, type: String
  field :activity_type, type: String
  field :description, type: String
  field :start_at, type: Date
  field :end_at, type: Date
  
  validates_uniqueness_of :name
  validates_presence_of :name, :start_at, :activity_type
  index({ name: 1 }, { unique: true, drop_dups: true, name: "name_index" })
  
  has_and_belongs_to_many :responsible_organisations, class_name: 'Partner', inverse_of: :activities_leading
  
  accepts_nested_attributes_for :responsible_organisations, allow_destroy: true
  embeds_many :photos, as: :photographic, cascade_callbacks: true
  accepts_nested_attributes_for :photos, allow_destroy: true
  slug :name
  
  
end
