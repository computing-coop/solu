class SearchController < ApplicationController
  
  def create
    if params[:searchterm]
      @projects = Project.published.search(params[:searchterm])
      @news = Post.published.search(params[:searchterm])
      @activities = Activity.published.search(params[:searchterm])
    else
      flash[:notice] = 'You must enter a search term.'
      redirect_to '/'
    end
    
  end
  
end