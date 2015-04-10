class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MagicCounterCache
  field :comment, type: String
  field :user_id, type: Integer
  embedded_in :submission, polymorphic: true
  counter_cache :submission
  belongs_to :user
end
