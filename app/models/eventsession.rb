class Eventsession
  include Mongoid::Document
  include Mongoid::Timestamps

  field :start_at, type: Time
  field :end_at, type: Time
  field :location, type: String

  embedded_in :activity

  # before_save :set_timezone

  # def set_timezone
  #   die
  #   self.start_at = ActiveSupport::TimeZone.new('Europe/Helsinki').local_to_utc(self.start_at) if self.start_at.zone != 'UTC'
  #   self.end_at = ActiveSupport::TimeZone.new('Europe/Helsinki').local_to_utc(self.end_at) if self.end_at.zone != 'UTC'
  # end

end
