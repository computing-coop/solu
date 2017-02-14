class ProjectsController < ApplicationController
  
  def index
    @ongoing = Project.ongoing
    @old = Project.older
  end
  
end