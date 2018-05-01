class Node
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  
  field :name, type: String
  field :description, type: String
  field :subdomains, type: String
  
  slug :name, history: true
  
  validates_uniqueness_of :name
  validates_presence_of :name, :description, :subdomains
  
  embeds_many :frontitems
  has_many :pages, inverse_of: :node
  
  def to_hashtag
    "##{name.gsub(/\s*/, '')}"
  end
  
end