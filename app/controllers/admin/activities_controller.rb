class Admin::ActivitiesController < Admin::BaseController
  
  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @activities = Activity.all
    set_meta_tags title: 'Activities'
    respond_with(@activities)
  end

  def show
    set_meta_tags title: @activity.name
    redirect_to @activity
  end

  def new
    @activity = Activity.new
    set_meta_tags title: 'New activity'
    respond_with(@activity)
  end

  def edit
    set_meta_tags title: 'Edit activity'
  end

  def create
    @activity = Activity.new(activity_params)
    @activity.save
    respond_with(@activity)
  end

  def update
    @activity.update(activity_params)
    respond_with(@activity)
  end

  def destroy
    @activity.destroy
    respond_with(@activity)
  end

  private
    def set_activity
      @activity = Activity.find(params[:id])
    end

    def activity_params
      params.require(:activity).permit(:name, :activity_type, :description, :start_at, :end_at, photos_attributes: [:image, :id,  :_destroy], responsible_organisations_attributes: [:id, :_destroy])
    end
end
