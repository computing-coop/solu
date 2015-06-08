class Activitytype
  include Mongoid::Document
  field :name, type: String
  has_many :activities
end
