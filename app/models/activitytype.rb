class Activitytype
  include Mongoid::Document
  field :name, type: String
  field :sort_order, type: Integer
  has_many :activities, :dependent => :delete
end
