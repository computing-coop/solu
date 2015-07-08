class Activitytype
  include Mongoid::Document
  field :name, type: String
  field :sort_order, type: Integer
  has_many :activities, :dependent => :delete
  field :show_in_secondary_menu, type: Boolean
  field :secondary_menu_name, type: String
  
  scope :secondary_menu, -> () { where(show_in_secondary_menu: true) }
  
end
