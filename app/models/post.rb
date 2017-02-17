class Post
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  field :title, type: String
  field :body, type: String
  field :published, type: Mongoid::Boolean
  field :published_at, type: Time
  field :sticky, type: Mongoid::Boolean
  field :short_abstract, type: String
  belongs_to :user
  belongs_to :subsite, optional: true
  belongs_to :node
  belongs_to :project, optional: true
  
  field :wordpress_scope, type: String
  field :wordpress_author, type: String
  field :wordpress_id, type: Integer
  
  has_and_belongs_to_many :postcategories
  has_and_belongs_to_many :activities
  slug :title, history: true
  before_save :remove_p_from_iframe
  embeds_many :photos, as: :photographic, cascade_callbacks: true
  accepts_nested_attributes_for :photos, allow_destroy: true
  
  scope :published, -> () { where(published: true)}
  scope :sticky, ->() { where(published: true, sticky: true) }
  scope :by_subsite, -> (x) { where(subsite_id: x).where(published: true)}
  
  before_save :check_published_date
  
  validates_presence_of :title, :body, :user_id
  
  # field :position, type: Integer
  # index({ position: 1, _id: 1 })
      
      
  def remove_p_from_iframe
    self.body = self.body.gsub(/<p><iframe\s*/, '<iframe ').gsub(/<\/iframe><\/p>/, '</iframe>')
  end
  
  def check_published_date
    if self.published == true
      self.published_at ||= Time.now
    end
  end
  
  def category
    [activities.map{|x| x.subsite? ? '<a href="http://' + x.subsite.hostname + '">' + x.name + '</a>' : '<a href="/activities/' + x.slug + '/posts">' + x.name + '</a>'}, postcategories.map{|x|  '<a href="/category/' + x.slug + '">' + x.name + '</a>'}].flatten.compact.join(' / ')
  end
  

  def previous
    Post.published.where(:published_at.lt => published_at).order_by([:published_at, :asc]).last
  end

  def next
    Post.published.where(:published_at.gt => published_at).order_by([:published_at, :asc]).first
  end
  
end
