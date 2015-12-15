class Work
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  
  field :title, type: String
  field :description, type: String
  belongs_to :artist
  belongs_to :activity
  
  slug :title, history: true
  
  embeds_many :photos, as: :photographic, cascade_callbacks: true
  accepts_nested_attributes_for :photos, allow_destroy: true
  
  validates_presence_of :activity_id, :artist_id, :title
  
end
