class Submission
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  
  embedded_in :call
  
  field :first_name, type: String
  field :last_name, type: String
  field :address, type: String
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

  slug :name, :scope => :call
  
  embeds_many :comments #, as: :commentable, cascade_callbacks: true
  accepts_nested_attributes_for :comments, allow_destroy: true
  
  embeds_many :votes, cascade_callbacks: true
  embeds_many :answers, cascade_callbacks: true
  accepts_nested_attributes_for :answers
  accepts_nested_attributes_for :votes, allow_destroy: true
  
  def name
    [first_name, last_name].join(' ')
  end
  
end
