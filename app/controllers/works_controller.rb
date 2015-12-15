class WorksController < ApplicationController
  
  def index
    if @activity.nil?
      @works = Work.order(start_at: :desc)
      set_meta_tags title: "Works"
     
    else
      @works = @activity.works.order(title: :asc)
      set_meta_tags title: @activity.name + ": Works"

    end
    render layout: @site.layout
  end
  
  def show
    @work = Work.find(params[:id])

    if @work.activity && params[:place].nil?
      case @work.activity.slug
      when 'hybrid-matters-exhibition-i'
        redirect_to '/grenland' + request.path
      when 'hybrid-matters-exhibition-ii'
        redirect_to '/nikolaj' + request.path
      when 'hybrid-matters-exhibition-iii'
        redirect_to '/forumbox' + request.path                
      end
    else
      set_meta_tags title: @work.title
      render layout: @site.layout
    end
  end
      
end