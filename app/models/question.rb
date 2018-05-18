class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  field :question, type: String
  field :question_type, type: String
  field :hint, type: String
  field :required, type: Mongoid::Boolean
  field :char_limit, type: Integer
  validates_presence_of :question_type
  belongs_to :call
  
  index({ question: 1 }, { unique: false, drop_dups: false, name: "question_index" })
    
end
