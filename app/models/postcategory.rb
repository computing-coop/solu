class Postcategory
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  
  has_and_belongs_to_many :posts
  
  field :name, type: String
  field :wordpress_id
  belongs_to :project, optional: true
  
  slug :name
  validates_uniqueness_of :name, scope: :project
  
end
