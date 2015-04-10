class Vote
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MagicCounterCache
  field :vote, type: Integer
  # field :user_id, type: BSON::ObjectId
  embedded_in :submission
  validates_uniqueness_of :user_id
  validates_presence_of :user_id, :vote
  counter_cache :submission
  # def self.user
  #   User.find(user_id)
  # end
  belongs_to :user
  
end