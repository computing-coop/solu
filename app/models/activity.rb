class Activity
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  include Mongoid::Taggable
  include Mongoid::Search
  # include Relatable

  field :name, type: String
  field :activity_type, type: String
  field :description, type: String
  field :abstract, type: String
  field :start_at, type: Date
  field :end_at, type: Date
  field :published, type: Mongoid::Boolean
  field :place_slug, type: String
  field :hide_from_whats_new, type: Boolean
  field :location, type: String

  has_many :pages
  has_and_belongs_to_many :works
  belongs_to :activitytype, optional: true
  has_one :subsite
  belongs_to :node
  # belongs_to :project, optional: true
  has_and_belongs_to_many :projects
  belongs_to :postcategory, optional: true
  has_and_belongs_to_many :posts
  has_and_belongs_to_many :responsible_organisations, class_name: 'Partner', inverse_of: :activities_leading
  has_many :events
  embeds_many :eventsessions, cascade_callbacks: true
  embeds_many :photos, as: :photographic, cascade_callbacks: true
  has_and_belongs_to_many :partners, inverse_of: :activities
  
  validates_uniqueness_of :name
  validates_presence_of :name, :start_at, :activitytype_id, :end_at
  
  search_in :name, :description, :abstract
  index({ name: 1 }, { unique: true, drop_dups: true, name: "name_index" })
  index({ description: "text", name: "text", location: "text" })

  accepts_nested_attributes_for :eventsessions, allow_destroy: true, reject_if: ->(attrs) { attrs[:start_at].blank? || attrs[:end_at].blank? }
  accepts_nested_attributes_for :responsible_organisations, allow_destroy: true
  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :projects, allow_destroy: true
  
  slug :name, history: true

  scope :published, -> () { where(published: true) }
  scope :by_node, -> (x) { where(node_id: x) }



  def self.search(q)
    Activity.where({ :$text => { :$search => q, :$language => "en" } })
  end

  def hmlogo
    if responsible_organisations.empty?
      'hm_logo.png'
    else
      responsible_organisations.first.hmlogo.url
    end
  end

  def sort_date
    s = eventsessions.empty? ? end_at : eventsessions.sort_by(&:start_at).last.end_at
    s.nil? ? updated_at : s
  end

  def title
    name
  end

  def short_abstract
    abstract.blank? ? description : abstract
  end

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

  def url_name
    if name =~ /Kunsthall Grenland$/i
      'grenland'
    elsif name =~ /Nikolaj Kunsthal$/i
      'nikolaj'
    elsif name =~ /FORUM BOX$/i
      'forumbox'
    else
      ''
    end
  end

  def index_image
    photos.empty? ? "background: #d8d9db url(/assets/bioart/images/placeholder.png) center/cover no-repeat" :  "background: #d8d9db url(#{photos.first.image.url(:box)}) center/cover no-repeat;"
  end

  def published?
    published
  end

    
  def related_content
    related = []
    related += Post.tagged_with_any(self.tags_array)
    related += Page.tagged_with_any(self.tags_array)
    related += Activity.tagged_with_any(self.tags_array)
    related += Project.tagged_with_any(self.tags_array)
    if self.class == Activity
      unless self.activitytype.nil?
        related += self.activitytype.activities.delete_if{|x| x==self }
      end
    end
    unless self.postcategory.nil?
      related += self.postcategory.posts.delete_if{|x| x==self }
    end
    related.compact.delete_if{|x| x == self}.delete_if{|x| x.node != self.node}.uniq
  end
end
