class Subsite
  include Mongoid::Document
  field :name, type: String
  field :subdomains, type: String
  field :layout, type: String
  field :symposium_id
  field :activity_id
  
  has_many :pages

  belongs_to :symposium
  belongs_to :activity
  belongs_to :node
  

  def subdomain_list
    subdomains.split(/,/).flatten.map(&:strip).uniq.compact
  end
  
  def hostname
    subdomains.split(',').compact.first.strip.downcase + ".hybridmatters.net"
  end
  
  def subdomain
    subdomains.split(',').compact.first.strip.downcase 
  end
end
