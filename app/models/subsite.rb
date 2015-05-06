class Subsite
  include Mongoid::Document
  field :name, type: String
  field :subdomains, type: String
  has_many :pages
end
