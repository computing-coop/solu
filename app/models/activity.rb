class Activity
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  field :name, type: String
  field :activity_type, type: String
  field :description, type: String
  field :start_at, type: Date
  field :end_at, type: Date
  field :show_in_secondary_menu, type: Boolean
  field :secondary_menu_name, type: String
  
  belongs_to :activitytype
  has_one :subsite
  has_and_belongs_to_many :posts
  
  validates_uniqueness_of :name
  validates_presence_of :name, :start_at, :activity_type
  index({ name: 1 }, { unique: true, drop_dups: true, name: "name_index" })
  
  has_and_belongs_to_many :responsible_organisations, class_name: 'Partner', inverse_of: :activities_leading
  has_many :events
  
  accepts_nested_attributes_for :responsible_organisations, allow_destroy: true
  embeds_many :photos, as: :photographic, cascade_callbacks: true
  accepts_nested_attributes_for :photos, allow_destroy: true
  slug :name, history: true
  
  scope :secondary_menu, -> () { where(show_in_secondary_menu: true) }
  
  def box_colour
    if responsible_organisations.empty?
      "ffffff"
    else
      responsible_organisations.first.css_colour
    end
  end
  
  def box_date
    # same year
    if end_at.nil?
       return "<div class='month'>#{start_at.strftime("%m")}</div><div class='year'>#{start_at.year}</div>".html_safe
    else
      if start_at.year == end_at.year
        if start_at.month == end_at.month
          return "<div class='month'>#{start_at.strftime("%m")}</div><div class='year'>#{start_at.year}</div>".html_safe
          
        else
           return "<div class='alone_year'>#{start_at.year}</div>".html_safe
        end
      end
    end
  end
  
  def is_whole_year?
    return false if end_at.nil?
    return true if start_at.year == end_at.year && (start_at.month == 1 && start_at.day == 1 && end_at.day == 31 && end_at.month == 12)
  end
end
