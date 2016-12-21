class Event
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  
  field :name, type: String
  field :start_at, type: Date
  field :end_at, type: Date
  field :place, type: String
  field :description, type: String
  field :published, type: Mongoid::Boolean
  
  belongs_to :activity
  belongs_to :subsite, optional: true
  belongs_to :node
  
  slug :name, history: true
  
  embeds_many :photos, as: :photographic, cascade_callbacks: true
  accepts_nested_attributes_for :photos, allow_destroy: true
  
  scope :published, -> () { where(published: true)}
  scope :by_subsite, -> (x) { where(subsite_id: x).where(published: true)}
  
  validates_presence_of :name, :place, :start_at, :end_at
  
  def previous
    Event.by_subsite(subsite_id).published.where(:start_at.lt => start_at).order_by([:start_at, :asc]).last
  end

  def next
    Event.by_subsite(subsite_id).published.where(:start_at.gt => start_at).order_by([:start_at, :asc]).first
  end
  
  
end
