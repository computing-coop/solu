class PostsController < ApplicationController

  respond_to :html, :rss

  def index
    @posts = Post.published.order(published_at: :desc)
    set_meta_tags title: "Posts"
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
    respond_with(@post)
  end

end
