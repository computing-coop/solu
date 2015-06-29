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
      @event = @site.symposium.events.find(params[:id])
      set_meta_tags title: @site.symposium.name + ": " + @event.name
      render layout: @site.layout
    end
  end
      
end