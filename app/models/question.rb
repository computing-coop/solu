class Question
  include Mongoid::Document
  include Mongoid::Timestamps
  field :question, type: String
  field :question_type, type: String
  field :required, type: Mongoid::Boolean
  belongs_to :call
  
  index({ question: 1 }, { unique: true, drop_dups: true, name: "question_index" })
    
end
