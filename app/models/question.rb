class Question
  include Mongoid::Document
  field :question, type: String
  field :question_type, type: String
  field :required, type: Mongoid::Boolean
    
  index({ question: 1 }, { unique: true, drop_dups: true, name: "question_index" })
    
end
