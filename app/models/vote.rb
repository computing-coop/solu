class Vote
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MagicCounterCache
  field :vote, type: Integer

  embedded_in :submission
  validates_uniqueness_of :user_id
  validates_presence_of :user_id, :vote
  counter_cache :submission

  belongs_to :user
  
end