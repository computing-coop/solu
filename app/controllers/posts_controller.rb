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
    if @post.subsite
      render layout: @post.subsite.layout
    elsif !@post.activities.empty?
      if @post.activity.first.subsite
        render layout: @post.activity.first.subsite.layout
      end
    else
      respond_with(@post)
    end
  end

end
