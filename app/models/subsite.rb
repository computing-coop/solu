class Subsite
  include Mongoid::Document
  field :name, type: String
  field :subdomains, type: String
  field :layout, type: String
  has_many :pages
  
  def subdomain_list
    subdomains.split(/,/).flatten.map(&:strip).uniq.compact
  end
  
end
