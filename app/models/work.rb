class Work
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  
  field :title, type: String
  field :description, type: String
  #belongs_to :artist
  has_and_belongs_to_many :activities
  has_and_belongs_to_many :artists
  
  slug :title, history: true
  
  embeds_many :photos, as: :photographic, cascade_callbacks: true
  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :artists, allow_destroy: true
  validates_presence_of  :title
  validate :has_activity?
  validate :has_artists?
  
  def has_artists?
    errors[:base] << 'Work must have at least one artist.' if self.artists.blank?
  end
  
  def has_activity?
    errors[:base] <<  "Work must belong to at least one exhibition." if self.activities.blank?
  end

  def activity_list
    activities.map{|x| '<a href="/' + x.url_name + '">' + x.name + '</a>'}.flatten.compact.uniq.join(' / ')
  end
  
  def artist_names
    artists.blank? ? '' :  artists.sort_by(&:alphabetical_name).map{|x| '<a href="/artists/' + x.slug + '">' + x.name + '</a>'}.join(' and ')
  end
  
end
