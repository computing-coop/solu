class PostcategoriesController < ApplicationController
  
  def show
    @category = Postcategory.find(params[:id])
    @posts = @category.posts
    
    render template: 'posts/index'
    
  end
  
end