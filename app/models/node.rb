class Node
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  
  field :name, type: String
  field :description, type: String
  field :subdomains, type: String
  
  slug :name, history: true
  
  validates_uniqueness_of :name
  
end