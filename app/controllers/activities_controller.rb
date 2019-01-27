class ActivitiesController < ApplicationController

  def index
    @activities = Activity.by_node(@node.id).published.asc(:start_at)
    set_meta_tags title: "Activities"
  end

  def show
    @activity = Activity.find(params[:id])
    set_meta_tags title: @activity.name
    if !@activity.published?
      if user_signed_in? && current_user.has_role?(:admin)
        flash[:notice] = 'DRAFT, not published yet'
        render template: 'activities/show'
      else
        flash[:error] = 'That activity is not yet published.'
        redirect_to activities_path
      end
    else
      render template: 'activities/show'
    end
  end

end
