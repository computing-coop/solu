class FeedsController < ApplicationController

  def index
    @feed = Post.published.order('published_at DESC').page(params[:page]).per(25)
    respond_to do |format|
      #format.html
      format.rss
    end
    
  end
  
end