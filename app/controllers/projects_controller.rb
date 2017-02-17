class ProjectsController < ApplicationController
  
  def index
    @ongoing = Project.ongoing
    @old = Project.older
  end
  
  def show
    @project = Project.find(params[:id])
    @about = @project.pages.find_by(is_project_overview: true)
  end
end