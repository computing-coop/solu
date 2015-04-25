class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MagicCounterCache
  field :comment, type: String
  field :user_id, type: Integer
  embedded_in :submission, inverse_of: :comments
  counter_cache :submission
  belongs_to :user
end
