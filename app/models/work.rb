class Work
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  
  field :title, type: String
  field :description, type: String
  belongs_to :artist
  has_and_belongs_to_many :activities
  
  slug :title, history: true
  
  embeds_many :photos, as: :photographic, cascade_callbacks: true
  accepts_nested_attributes_for :photos, allow_destroy: true
  
  validates_presence_of :artist_id, :title


  def activity_list
    activities.map{|x| '<a href="/' + x.url_name + '">' + x.name + '</a>'}.flatten.compact.join(' / ')
  end
  
    
end
