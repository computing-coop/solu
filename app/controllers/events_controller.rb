class EventsController < ApplicationController
  include ActionView::Helpers::TextHelper
  def index
    if @site.nil?
      # @events = Activity.where(:eventsessions.ne => nil).desc("eventsessions.start_at").page(params[:page]).per(12)
      @activities = Activity.by_node(@node.id).published.desc(:start_at)
      if @node.name == 'hybrid_matters'
        @events = @activities.map{|x| x.events.published.order(start_at: :desc) }.flatten
      end
      set_meta_tags title: "Events"
    else
      if @site.activity.nil?
        redirect_to 'https://hybridmatters.net/'
      else
        @events = @site.activity.events.published.order(start_at: :desc)
        set_meta_tags title: @site.name + ": Events"
        render layout: @site.layout
      end
    end
  end

  def show
    if @node.slug == 'bioart'
      @activity = Activity.find(params[:id])
      set_meta_tags title: @activity.name,
        og: { title: @activity.name, type: 'article',
          url: url_for(@activity),
          description: ActionView::Base.full_sanitizer.sanitize(truncate(strip_tags(@activity.description), length: 400)),
          image: @activity.photos.empty? ? false : @activity.photos.first.image.url(:box)
        },
        canonical: url_for(@activity)
      if !@activity.published?
        if user_signed_in? && current_user.has_role?(:admin)
          flash[:notice] = 'DRAFT, not published yet'
          render template: 'activities/show'
        else
          flash[:error] = 'That activity is not yet published.'
          redirect_to activities_path
        end
      else
        render template: 'activities/show'
      end
    else
      if @site.nil?

        @event = Event.find(params[:id])
        if @event.subsite
          # render layout: @event.subsite.layout
          redirect_to subdomain: @event.subsite.subdomain
        elsif @event.activity
          if @event.activity.subsite
            redirect_to subdomain: @event.activity.subsite.subdomain
          end
        end
      else
        if @site.symposium
          if @site.activity
            begin
              @event = @site.activity.events.find(params[:id])
              set_meta_tags title: @site.symposium.name + ": " + @event.name
            rescue
              redirect_to '/' and return
            end
          end
        else
          if @site.activity
            @event = @site.activity.events.find(params[:id])
            set_meta_tags title: @site.name + ": " + @event.name
          end
        end
        render layout: @site.layout
      end
    end
  end
end
