# -*- encoding : utf-8 -*-
class CalendarController < ApplicationController
#
#   def index
#     @period = [Time.now.strftime("%Y").to_i, Time.now.strftime('%m').to_i]
#   end
#
#   def update_calendar
#     @period = [params[:year], params[:month]]
#
#     render :layout => false, :template => 'calendar/index'
#   end
# end
  def index
    # render_cached_json("cal_" + params[:start] + "_" + params[:end], expires_in: 1.hour) do
      events = Activity.where(nil)

      events = Activity.where(:eventsessions.ne => nil)


      @events = []
      #if @location.id != 3

      @events += events.map(&:eventsessions).flatten.map(&:as_json)
      no_instances = events.to_a.delete_if{|x| !x.eventsessions.empty? || (x.end_at.to_date - x.start_at.to_date).to_i > 10 }.map(&:as_json)
      unless no_instances.nil?
        @events += no_instances
      end

      # delete really long events
      if params[:format] == 'ics'
        require 'icalendar/tzinfo'
        @cal = Icalendar::Calendar.new
        @cal.prodid = '-//SOLU, Helsinki//NONSGML ExportToCalendar//EN'

        tzid = "Europe/Helsinki"
        tz = TZInfo::Timezone.get tzid
        @events.each do |event|
          @cal.event do |e|
            e.dtstart     = Icalendar::Values::DateTime.new(event[:start].to_datetime, 'tzid' => tzid)
            e.dtend       = Icalendar::Values::DateTime.new(event[:end].to_datetime, 'tzid' => tzid)
            e.summary     = event[:title]
            e.location  = event[:location]
            e.description = ActionController::Base.helpers.strip_tags event[:description]
            e.ip_class = 'PUBLIC'
            e.url = e.uid = 'https://solu.earth' + event[:url]
          end
        end
        @cal.publish
      end


      # else
  #       @events = events
  #     end
      respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => @events }
        format.ics { render plain: @cal.to_ical }
      end
    # end
  end

  def render_cached_json(cache_key, opts = {}, &block)
    opts[:expires_in] ||= 1.minute


    expires_in opts[:expires_in], :public => true
    data = Rails.cache.fetch(cache_key, {raw: true}.merge(opts)) do

      block.call.to_json
    end

    render :json => data
  end


  def show
    @event = Event.friendly.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @event }
    end
  end

end
