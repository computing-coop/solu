class PagesController < ApplicationController

  respond_to :html



  def show
    @page = Page.find(params[:id])
    set_meta_tags title: @page.title
    respond_with(@page)
  end

 
  private

    def page_params
      params.require(:page).permit(:title, :published, :body, :image, :image_file_size, :image_width, :image_height, :image_content_type)
    end
end
