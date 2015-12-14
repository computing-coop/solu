class Work
  include Mongoid::Document
  field :title, type: String
  field :description, type: String
  belongs_to :artist
  belongs_to :activity
end
