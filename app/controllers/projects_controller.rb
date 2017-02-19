class ProjectsController < ApplicationController
  
  def index
    @ongoing = Project.ongoing
    @old = Project.older
  end
  
  def show
   
    @project = Project.find(params[:id])
    if @project.redirect_url
      redirect_to @project.redirect_url
    else
      
      if @node.slug != 'bioart'
        redirect_to project_url(@project, subdomain: Node.find('bioart').subdomains)
      else
        @about = @project.pages.find_by(is_project_overview: true) rescue nil
      end

    end
    
  end


end