class Admin::ActivitiesController < Admin::BaseController
  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  respond_to :html
  handles_sortable_columns


  def index
    order = sortable_column_order do |column, direction|
      case column
      when "name"
        "name #{direction}"
      when "start_at"
        "start_at #{direction}"

      else
        "start_at asc"
      end
    end
    @activities = Activity.by_node(@node.id).order(order)
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
    respond_with @activity, location: admin_activities_path
  end

  def destroy
    @activity.destroy
    respond_with @activity, location: admin_activities_path
  end

  private
    def set_activity
      @activity = Activity.find(params[:id])
    end

    def activity_params
      params.require(:activity).permit(:name, :activitytype_id, :node_id, :location, :description, :place_slug, 
      :start_at, :project_id, :end_at, photos_attributes: [:image, :id,  :_destroy], 
      responsible_organisations_attributes: [:id, :_destroy], 
      responsible_organisation_ids: [])
    end
end
