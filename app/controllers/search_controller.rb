class SearchController < ApplicationController
  
  def create
    if params[:searchterm]
      @projects = Project.published.full_text_search(params[:searchterm], relevant_search: true)
      @news = Post.published.full_text_search(params[:searchterm], relevant_search: true)
      @activities = Activity.published.full_text_search(params[:searchterm], relevant_search: true)
    else
      flash[:notice] = 'You must enter a search term.'
      redirect_to '/'
    end
    
  end
  
end