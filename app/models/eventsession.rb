class Eventsession
  include Mongoid::Document
  include Mongoid::Timestamps

  field :start_at, type: Time
  field :end_at, type: Time
  field :location, type: String

  embedded_in :activity
  validates :end_at, presence: true
  validates :start_at, presence: true
  validate :end_after_start
  # before_save :set_timezone

  # def set_timezone
  #   die
  #   self.start_at = ActiveSupport::TimeZone.new('Europe/Helsinki').local_to_utc(self.start_at) if self.start_at.zone != 'UTC'
  #   self.end_at = ActiveSupport::TimeZone.new('Europe/Helsinki').local_to_utc(self.end_at) if self.end_at.zone != 'UTC'
  # end
  def as_json(options = {})
    {
      :id => self.id.to_s,
      :title =>  self.activity.name,
      :description => self.activity.description || "",
      location: location.blank? ? 'SOLU' : self.location,
      :start => start_at.in_time_zone.strftime('%Y-%m-%d %H:%M:00'),
      :end => end_at.in_time_zone.strftime('%H:%M') == '23:59' ? '??' : end_at.in_time_zone.strftime('%Y-%m-%d %H:%M:00'),
      :allDay => false,
      :recurring => false,
      :exhibition => ((end_at - start_at) / 60 / 60 / 24 ) > 3 ? true : false,
      :url => Rails.application.routes.url_helpers.activity_path(self.activity.slug)
    }

  end

  private

  def end_after_start
    return if end_at.blank? || start_at.blank?
    if end_at < start_at
      errors.add(:end_at, "must be after starting time")
    end
  end
end
