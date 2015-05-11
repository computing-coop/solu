class Symposium
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  
  field :name, type: String
  field :start_at, type: Date
  field :end_at, type: Date
  field :location, type: String
  field :location_url, type: String

  slug :name
  
  has_one :subsite
  
  
  has_many :calls
  embeds_many :groups, cascade_callbacks: true
  accepts_nested_attributes_for :groups, allow_destroy: true,  reject_if: :all_blank
  
  validates_presence_of :start_at, :name, :end_at
end
