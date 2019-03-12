class PostsController < ApplicationController

  respond_to :html, :rss, :js

  def index
    if @node.name == 'bioart'
      if params[:project_id]
        @project = Project.find(params[:project_id])
        @posts = @project.posts.published.order(published_at: :desc).page(params[:page]).per(12)
        set_meta_tags title: @project.name + ": Blog"
      else
        @posts = Post.published.order(published_at: :desc).page(params[:page]).per(12)      
      end
      if request.xhr?
        render layout: false, partial: 'postspage'
      end
    else
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
          render layout: 'application' #@site.layout
        end
      else
        if @site
    
            @posts = Post.by_subsite(@site.id).published.order(published_at: :desc)
            set_meta_tags title: @site.name + ": News"
            render layout: @site.layout
  
        else

          @posts = Post.by_node(@node.id).published.order(published_at: :desc)
          set_meta_tags title: "News"
        end
      end
    end
  end

  def show
    if @node.name == 'bioart'      
      if params[:project_id]
        @project = Project.find(params[:project_id])
        @post = @project.posts.find(params[:id])
        unless @post.postcategories.empty?
          unless @post.postcategories.map(&:page).compact.empty?
            @page = @post.postcategories.map(&:page).first
          end
        end
      else
        @post = Post.find(params[:id])
        set_meta_tags title: @post.title,
          og: { title: @post.title, type: 'article',
            url: url_for(@post),
            image: @post.photos.empty? ? false : @post.photos.first.image.url(:box)
          },
          canonical: url_for(@post)
        if @post.project
          redirect_to project_post_url(@post.project, @post)
        end
      end
    else
      @post = Post.find(params[:id])
      if @post.node != @node
        if @post.node.name == 'bioart'
          redirect_to host: 'bioartsociety.fi'
        else
          redirect_to subdomain: @post.node.subdomains
        end
      else
        set_meta_tags title: @post.title
        if @site.nil?
          if @post.subsite
            redirect_to subdomain: @post.subsite.subdomain #layout: @post.subsite.layout
          elsif !@post.activities.empty?
            if @post.activities.first.subsite
              redirect_to subdomain: @post.activities.first.subsite.subdomain #render layout: @post.activity.first.subsite.layout
            end
          end

        else
          # check it's right layout
          if @post.subsite
            if @site != @post.subsite
              redirect_to request.url.sub(@site.subdomain, @post.subsite.subdomain)
            else
              render layout: @site.layout
            end
          elsif !@post.activities.empty?
            if @site != @post.activities.first.subsite && !@post.activities.first.subsite.nil?
              redirect_to request.url.sub(@site.subdomain, @post.activities.first.subsite.subdomain)
            else
              render layout: @site.layout
            end
          else
            render layout: @site.layout
          end
        end
      end
    end
  end

end
