class PostsController < ApplicationController

  respond_to :html, :rss

  def index
    @posts = Post.published.order(published_at: :desc)
    set_meta_tags title: "News"
    if @site
      @posts = Post.by_subsite(@site.id).published.order(published_at: :desc)
      render layout: @site.layout
    else
      @posts = Post.published.order(published_at: :desc)
    end
    
  end

  def show
    @post = Post.find(params[:id])
    set_meta_tags title: @post.title
    if @site.nil?
      if @post.subsite
        redirect_to subdomain: @post.subsite.subdomain #layout: @post.subsite.layout
      elsif !@post.activities.empty?
        if @post.activities.first.subsite
          redirect_to subdomain: @post.activities.first.subsite.subdomain #render layout: @post.activity.first.subsite.layout
        end
      end
      render 
    else
      # check it's right layout
      if @post.subsite
        if @site != @post.subsite
          redirect_to request.url.sub(@site.subdomain, @post.subsite.subdomain)
        else
          render layout: @site.layout
        end
      elsif !@post.activities.empty?
        if @site != @post.activities.first.subsite
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
