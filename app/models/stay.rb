class Stay
  include Mongoid::Document
  include Mongoid::Timestamps
  field :start_at, type: Date
  field :end_at, type: Date
  field :residency_description, type: String

  belongs_to :artist
  embeds_many :photos, as: :photographic, cascade_callbacks: true
  accepts_nested_attributes_for :photos, allow_destroy: true
  validates_presence_of :start_at, :end_at
  has_many :posts
end