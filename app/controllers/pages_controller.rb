class PagesController < ApplicationController

  respond_to :html
  
  def curatorial_statement
    if @activity.nil?
      redirect_to 'exhibitions.' + request.domain
    else
      @page = @activity.pages.first
      set_meta_tags title: @activity.name
      render layout: @site.layout, template: 'pages/show'
    end
  end


  def show
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @page = @project.pages.find(params[:id])
    else
      @page = Page.find(params[:id])
    end
    
    set_meta_tags title: @page.title
    if @page.subsite
      unless @page.subsite.layout.blank?
        # redirect URL
        if @page.subsite.subdomain_list.include?(request.host.split(/\./).first)
          render layout: @page.subsite.layout
        else
          redirect_to page_url(@page, subdomain: @page.subsite.subdomain_list.first)
        end
      end
    end
    
  end

 
  private

    def page_params
      params.require(:page).permit(:title, :published, :body, :image, :image_file_size, :image_width, :image_height, :image_content_type)
    end
end
