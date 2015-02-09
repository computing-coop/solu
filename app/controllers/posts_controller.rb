class PostsController < ApplicationController

  respond_to :html

  def index
    @posts = Post.all
    respond_with(@posts)
    set_meta_tags title: "Posts"
  end

  def show
    @post = Post.find(params[:id])
    set_meta_tags title: @post.title
    respond_with(@post)
  end

end
