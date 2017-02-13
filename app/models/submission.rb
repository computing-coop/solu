class Submission
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  
  embedded_in :call
  
  field :first_name, type: String
  field :last_name, type: String
  field :address, type: String
  field :profession, type: String
  field :city, type: String
  field :country, type: String
  field :date_of_birth, type: Date
  field :organisation_name, type: String
  field :nationality, type: String
  field :short_biography, type: String
  field :email, type: String
  field :website, type: String
  field :vote_count
  field :comment_count
  field :vote_average, type: Float
  field :preferred_start, type: Date
  field :preferred_end, type: Date
  slug :name, :scope => :call
  
  embeds_many :comments #, as: :commentable, cascade_callbacks: true
  accepts_nested_attributes_for :comments, allow_destroy: true
  
  embeds_many :votes, cascade_callbacks: true
  embeds_many :answers, cascade_callbacks: true
  accepts_nested_attributes_for :answers
  accepts_nested_attributes_for :votes, allow_destroy: true
  before_save :update_average
  
  def update_average
    unless self.votes.empty?
      self.vote_average = (self.votes.sum(:vote).to_f / self.votes.size.to_f)
    end
  end
  
  def name
    [first_name, last_name].join(' ')
  end

  
  def previous
     call.submissions.where(:created_at.lt => created_at).order_by([:created_at, :asc]).last
  end

  def next
    call.submissions.where(:created_at.gt => created_at).order_by([:created_at, :asc]).first
  end
    
end
