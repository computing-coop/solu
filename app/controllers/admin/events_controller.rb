class Admin::EventsController < Admin::BaseController
  
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @events = Event.all
    set_meta_tags title: 'Events'
    respond_with(@events)
  end

  def show
    redirect_to @event
  end

  def new
    @event = Event.new
    set_meta_tags title: 'New event'
    respond_with @event 
  end

  def edit
    set_meta_tags title: 'Edit event - ' + @event.try(:name)
  end

  def create
    @event = Event.new(event_params)
    @event.save
    respond_with @event, location: admin_events_path
  end

  def update
    @event.update(event_params)
    respond_with @event , location: admin_events_path
  end

  def destroy
    @event.destroy
    respond_with @event , location: admin_events_path
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:name, :start_at, :end_at, :place, :activity_id, :subsite_id,
        :description, :published, photos_attributes: [:image, :id,  :_destroy])
    end
end
