class Group
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  
  field :name, type: String
  field :host, type: String
  field :host_url, type: String
  field :short_description, type: String
  field :description, type: String
  
  slug :name
   
  embedded_in :symposium
  
end
