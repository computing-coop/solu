class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :comment, type: String
  field :user_id, type: Integer
  embedded_in :submission, polymorphic: true
  
end
