class PostcategoriesController < ApplicationController
  
  def show
    @category = Postcategory.find(params[:id])
    @posts = @category.posts
    if @site
      render template: 'posts/index', layout: @site.layout
    else
      render template: 'posts/index'
    end
    
  end
  
end