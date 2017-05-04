class HomeController < ApplicationController
  
  
  def about
    @about_text = @node.pages.find('about-the-bioart-society') rescue nil
    @board_staff = @node.pages.find('board-and-staff') rescue nil
    @members = @node.pages.find('members') rescue Page.new
    @collaborators = @node.pages.find('collaborators') rescue Page.new
    set_meta_tags title: "About"
  end
  
  def index
    @call = Call.first
    redirect_to @call
  end
  
  def home
    if @node.name == 'hybrid_matters'
      if @activity # if activity already exists from exhibitions URL
        @posts = @activity.posts.published.order(:published_at.desc)
        set_meta_tags title: 'Posts for activity ' + @activity.name
        render layout: @site.layout
      elsif params[:activity_id]
        @activity = Activity.find(params[:activity_id])
        if @activity.subsite && @site.nil?
          redirect_to subdomain: @activity.subsite.subdomain
        elsif @activity.activity_type == 'exhibition'
          if @activity.url_name.blank?
            redirect_to "http://exhibitions.hybridmatters.net/posts"
          else
            redirect_to "http://exhibitions.hybridmatters.net/#{@activity.url_name}/posts"
          end
        else
          @posts = @activity.posts.published.order(:published_at.desc)
          set_meta_tags title: 'Posts for  ' + @activity.name
          render layout: @site.layout, template: 'posts/index'
        end
      else

        if @site
          
            @posts = Post.by_subsite(@site.id).published.order(published_at: :desc)
            set_meta_tags title: @site.name + ": News"
            render layout: @site.layout, template: 'posts/index'
  
        else

          @posts = Post.by_node(@node).published.order(published_at: :desc)
          
          set_meta_tags title: "News"
          render template: 'posts/index'
        end
      end

    else
      @frontitems = @node.frontitems.published
      @posts = Post.published.order(published_at: :desc).limit(8)
      @about = @node.pages.find('about-the-bioart-society') rescue nil
      @ars = @node.pages.find('ars-bioarctica-front') rescue nil
      @calls = Project.friendly.find('ars-bioarctica').calls.active
      @projects = Project.published
    end
  end
end
