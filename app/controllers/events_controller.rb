class EventsController < ApplicationController
  
  def index
    if @site.nil?
      redirect_to '/'
    else
      @events = @site.activity.events.published.order(start_at: :asc)
      set_meta_tags title: @site.name + ": Events"
      render layout: @site.layout
    end
  end
  
  def show
    if @site.nil?
      redirect_to '/'
    else
      if @site.symposium
        @event = @site.symposium.events.find(params[:id])
        set_meta_tags title: @site.symposium.name + ": " + @event.name
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