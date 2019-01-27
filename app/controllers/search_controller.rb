class SearchController < ApplicationController
  
  def create
    @projects = Project.published.search(params[:searchterm])
    @news = Post.published.search(params[:searchterm])
    @activities = Activity.published.search(params[:searchterm])
    
  end
  
end