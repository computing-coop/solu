class Artist
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  
  field :name, type: String
  field :alphabetical_name, type: String
  field :bio, type: String
  field :country, type: String
  field :website, type: String
  
  slug :name, history: true
  
  embeds_many :photos, as: :photographic, cascade_callbacks: true
  accepts_nested_attributes_for :photos, allow_destroy: true
  
  
  has_many :works
  
  def sort_order
    alphabetical_name.blank? ? name : alphabetical_name
  end
  
end
