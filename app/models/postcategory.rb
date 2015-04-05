class Postcategory
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  
  has_and_belongs_to_many :posts
  
  field :name, type: String
  slug :name
  validates_uniqueness_of :name
  
end
