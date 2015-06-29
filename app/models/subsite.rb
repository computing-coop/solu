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
  

  def subdomain_list
    subdomains.split(/,/).flatten.map(&:strip).uniq.compact
  end
  
end
