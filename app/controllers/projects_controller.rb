class ProjectsController < ApplicationController
  
  def index
    @ongoing = Project.ongoing.published.order(year_range: :asc)
    @old = Project.older.published.order(year_range: :desc)
    set_meta_tags title: 'Projects'
  end
  
  def show
   
    @project = Project.find(params[:id])
    @calls = @project.calls.active
    unless @project.redirect_url.blank?
      redirect_to @project.redirect_url
    else
      
      if @node.slug != 'bioart'
        redirect_to project_url(@project, subdomain: Node.find('bioart').subdomains)
      else
        @about = @project.pages.find_by(is_project_overview: true) rescue nil
        set_meta_tags title: @project.name
      end

    end
    
  end


end