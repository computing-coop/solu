class Post
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  include Mongoid::Taggable
  include Mongoid::Search

  field :title, type: String
  field :body, type: String
  field :published, type: Mongoid::Boolean
  field :published_at, type: Time
  field :sticky, type: Mongoid::Boolean
  field :short_abstract, type: String

  field :wordpress_scope, type: String
  field :wordpress_author, type: String
  field :wordpress_id, type: Integer

  field :hide_featured_image, type: Boolean, default: false


  slug :title, history: true

  before_save :remove_p_from_iframe

  belongs_to :user
  belongs_to :subsite, optional: true
  belongs_to :node
  # belongs_to :project, optional: true
  
  belongs_to :stay, optional: true
  embeds_many :photos, as: :photographic, cascade_callbacks: true
  embeds_many :soundfiles, as: :soundable, cascade_callbacks: true
  embeds_many :videos, as: :videographic, cascade_callbacks: true
  has_and_belongs_to_many :postcategories
  has_and_belongs_to_many :activities
  has_and_belongs_to_many :projects

  accepts_nested_attributes_for :soundfiles, allow_destroy: true
  accepts_nested_attributes_for :photos, allow_destroy: true
  accepts_nested_attributes_for :videos, allow_destroy: true
  accepts_nested_attributes_for :projects, allow_destroy: true

  scope :published, -> () { where(published: true)}
  scope :sticky, ->() { where(published: true, sticky: true) }
  scope :by_subsite, -> (x) { where(subsite_id: x).where(published: true)}
  scope :by_node, -> (x) { where(node: x)}
  scope :by_project,  ->(x) {where(project_ids: x)}

  before_save :check_published_date


  validates_presence_of :title, :body, :user_id

  index({ body: "text", title: "text" })

  # field :position, type: Integer
  # index({ position: 1, _id: 1 })

  search_in :body
  search_in :title

  def self.search(q)
    posts = Post.full_text_search(q, match: :any) #({ :$text => { :$search => q, :$language => "en" } })
    users = User.full_text_search(q, match: :any) #({ :$text => { :$search => q}})
    posts += users.map(&:posts).flatten
    return posts.uniq
  end

  def remove_p_from_iframe
    self.body = self.body.gsub(/<p><iframe\s*/, '<iframe ').gsub(/<\/iframe><\/p>/, '</iframe>')
  end

  def sort_date
    self.published_at
  end

  def check_published_date
    if self.published == true
      self.published_at ||= Time.now
    end
  end

  def category
    [activities.map{|x| x.subsite? ?
      '<a href="http://' + x.subsite.hostname + '">' + x.name + '</a>' :
       '<a href="/activities/' + x.slug + '/posts">' + x.name + '</a>'}, postcategories.map{|x|  '<a href="/category/' + x.slug + '">' + x.name + '</a>'}
     ].flatten.compact.join(' / ')
  end

  def previous_by_project(project = projects.first)
    projects.empty? ?
      Post.published.by_node(node).where(:published_at.lt => published_at).order_by([:published_at, :asc]).last
      :
      Post.published.by_node(node).by_project(project).where(:published_at.lt => published_at).order_by([:published_at, :asc]).last
  end

  def next_by_project(project = projects.first)
    projects.empty? ?
      Post.published.by_node(node).where(:published_at.gt => published_at).order_by([:published_at, :asc]).first
      : Post.published.by_node(node).by_project(project).where(:published_at.gt => published_at).order_by([:published_at, :asc]).first
  end

  def previous
    Post.published.by_node(node).where(:published_at.lt => published_at).order_by([:published_at, :asc]).last
  end

  def next
    Post.published.by_node(node).where(:published_at.gt => published_at).order_by([:published_at, :asc]).first
  end

  def name
    title
  end

  def description
    body
  end

  def index_image
    photos.empty? ? "background: #d8d9db url(/assets/bioart/images/placeholder.png) center/cover no-repeat" :
    "background: #d8d9db url(#{photos.first.image.url(:box)}) center/cover no-repeat;"
  end

end
