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
    if @work.activities.size > 1
      redirect_to '/' + request.path
    else
      if !@work.activities.empty? && params[:place].nil?
       
        case @work.activities.first.slug
          when 'hybrid-matters-exhibition-at-kunsthall-grenland'
            redirect_to '/grenland' + request.path
          when 'hybrid-matters-exhibition-at-nikolaj-kunsthal'
            redirect_to '/nikolaj' + request.path
          when 'hybrid-matters-exhibition-at-forum-box'
            redirect_to '/forumbox' + request.path                
        end
      else

        set_meta_tags title: @work.title
        render layout: @site.layout
      end
    end

  end
      
end