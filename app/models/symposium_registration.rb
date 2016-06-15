class SymposiumRegistration
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MagicCounterCache
  field :keynote, type: Boolean
  field :symposium, type: Boolean
  field :dinner, type: Boolean
  field :dinner_paid, type: Boolean

  embedded_in :participant
  
end