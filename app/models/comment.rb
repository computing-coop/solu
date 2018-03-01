class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MagicCounterCache

  embedded_in :submission, inverse_of: :comments

  field :comment, type: String
  field :user_id, type: Integer

  counter_cache :submission
  belongs_to :user
end
