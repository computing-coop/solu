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
  
  
  has_and_belongs_to_many :works
  
  def sort_order
    alphabetical_name.blank? ? name : alphabetical_name
  end
  
  def exhibitions
    works.map(&:activities).flatten.compact.uniq
  end
  
  def exhibition_list
    exhibitions.map{|x| '<a href="/' + x.url_name + '">' + x.name + '</a>'}
  end
  
  def website_formatted
    if website.blank?
      return nil
    elsif website =~ /^http(s*):\/\//i 
      return website
    else
      return "http://#{website}"
    end
  end
end
