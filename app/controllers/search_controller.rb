class SearchController < ApplicationController
  
  def create
    @projects = Project.search(params[:searchterm])
    @news = Post.search(params[:searchterm])
    @activities = Activity.search(params[:searchterm])
    
  end
  
end