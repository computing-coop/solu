class EventsController < ApplicationController
  
  def index
    if @site.nil?
      @events = Event.published.order(start_at: :asc)
      set_meta_tags title: "Events"
    else
      @events = @site.activity.events.published.order(start_at: :asc)
      set_meta_tags title: @site.name + ": Events"
      render layout: @site.layout
    end
  end
  
  def show

    if @site.nil?

      @event = Event.find(params[:id])
      if @event.subsite
        # render layout: @event.subsite.layout
        
        redirect_to subdomain: @event.subsite.subdomain
      elsif @event.activity
        if @event.activity.subsite
          redirect_to subdomain: @event.activity.subsite.subdomain
        end
      end
    else


      if @site.symposium
        if @site.activity
          begin
            @event = @site.activity.events.find(params[:id])
            set_meta_tags title: @site.symposium.name + ": " + @event.name
          rescue
            redirect_to '/' and return
          end
        end
      else
        if @site.activity
          @event = @site.activity.events.find(params[:id])
          set_meta_tags title: @site.name + ": " + @event.name
        end
      end
      render layout: @site.layout
    
    end
  end
      
end