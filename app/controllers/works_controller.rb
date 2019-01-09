class WorksController < ApplicationController
 
  def index
    if params[:place]
      @activity = Activity.find_by(place_slug: params[:place])
    end
    if @activity.nil?
      @works = Work.order(start_at: :desc)
      set_meta_tags title: "Works"
    else
      @works = @activity.works.order(title: :asc)
      set_meta_tags title: @activity.name + ": Works"
    end
    render layout: 'exhibitions' #@site.layout
  end

  def show
    @work = Work.find(params[:id])

    if @work.activities.size > 1 && request.path =~ /\/(grenland|nikolaj|forumbox)/
      if Rails.env.development?      
        redirect_to 'http://exhibitions.local:3000' + request.path.gsub(/\/(grenland|nikolaj|forumbox)/, '')
      elsif Rails.env.staging?
        redirect_to 'http://exhibitions.staging.hybridmatters.net' + request.path.gsub(/\/(grenland|nikolaj|forumbox)/, '')
      elsif Rails.env.production?
        redirect_to 'http://exhibitions.hybridmatters.net' + request.path.gsub(/\/(grenland|nikolaj|forumbox)/, '')
      end
      # redirect_to request.host + '' + request.path
    else
      if !@work.activities.empty? && params[:place].nil?
        if @work.activities.size == 1
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
          redirect_to 'http://exhibitions.hybridmatters.net' + request.path       
        end
      else
        if request.host !~ /exhibitions/
          redirect_to 'http://exhibitions.hybridmatters.net' + request.path.gsub(/\/(grenland|nikolaj|forumbox)/, '')
        else
          set_meta_tags title: @work.title
          render layout: @site.layout
        end
      end
    end

  end
      
end