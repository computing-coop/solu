class Submission
  include Mongoid::Document
  embedded_in :call
  field :first_name, type: String
  field :last_name, type: String
  field :address, type: String
  field :city, type: String
  field :country, type: String
  field :date_of_birth, type: Date
  field :organisation_name, type: String
  field :nationality, type: String
  field :email, type: String
  field :website, type: String
  
  embeds_many :answers, cascade_callbacks: true
  accepts_nested_attributes_for :answers
  
end
