class Post
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  field :title, type: String
  field :body, type: String
  field :published, type: Mongoid::Boolean
  field :published_at, type: Time
  belongs_to :user
  has_and_belongs_to_many :postcategories
  slug :title
  
  embeds_many :photos, as: :photographic, cascade_callbacks: true
  accepts_nested_attributes_for :photos, allow_destroy: true
  
  scope :published, -> () { where(published: true)}
  before_save :check_published_date
  
  def check_published_date
    if self.published == true
      self.published_at ||= Time.now
    end
  end
  
  def previous
    Post.published.where(:published_at.lt => published_at).last
  end

  def next
    Post.published.where(:published_at.gt => published_at).first
  end
  
end
