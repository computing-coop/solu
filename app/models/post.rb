class Post
  include Mongoid::Document
  include Mongoid::Slug
  field :title, type: String
  field :body, type: String
  field :published, type: Mongoid::Boolean
  field :published_at, type: Time
  belongs_to :user
  slug :title
  
  embeds_many :photos, as: :photographic, cascade_callbacks: true
  accepts_nested_attributes_for :photos, allow_destroy: true
  
end
