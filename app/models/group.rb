class Group
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
   
  embedded_in :symposium
  
  
  field :name, type: String
  field :host, type: String
  field :host_url, type: String
  field :place, type: String
  field :short_description, type: String
  field :description, type: String
  
  slug :name #, :scope => :symposium

  embeds_many :participants, cascade_callbacks: true
  
end
