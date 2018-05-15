class Call
  include Mongoid::Document
  include Mongoid::Slug
  include Mongoid::Timestamps
  
  field :name, type: String
  field :start_at, type: Date
  field :end_at, type: Date
  field :published, type: Mongoid::Boolean
  field :active, type: Mongoid::Boolean
  field :overview, type: String
  field :ask_preferred_period, type: Mongoid::Boolean
  
  field :add_to_project_menu, type: Mongoid::Boolean
  
  slug :name
  
  belongs_to :node
  has_and_belongs_to_many :users
  belongs_to :project, optional: true
  belongs_to :symposium, optional: true
  
  embeds_many :photos, as: :photographic, cascade_callbacks: true
  accepts_nested_attributes_for :photos, allow_destroy: true,  reject_if: :all_blank
  
  has_many :questions
  accepts_nested_attributes_for :questions, allow_destroy: true,  reject_if: :all_blank
  
  embeds_many :submissions , cascade_callbacks: true
  
  scope :active, ->() { where(:start_at.lte => Time.current.to_date, :end_at.gte =>  Time.current.to_date) }
  scope :on_menu, ->() { where(add_to_project_menu: true) }
  
  def headings
    Nokogiri::HTML(self.overview).search('a[name]').map{|x| [x['name'], x.text] }.delete_if{|x| x.first.blank? }
  end
  
  def chunks
    Nokogiri::HTML(self.overview).at('body').inner_html.split(/<a\s+(?!href=).*?name=.*?<\/a>/i).drop(1)
  end
  
end
