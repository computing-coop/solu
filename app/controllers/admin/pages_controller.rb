class Admin::PagesController < Admin::BaseController
  
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @pages = Page.all
    set_meta_tags title: 'Pages'
    respond_with(@pages)
  end
  

  

  def show
    redirect_to @page
  end

  def new
    @page = Page.new
    set_meta_tags title: 'New page'
    respond_with(@page)
  end

  def edit
    set_meta_tags title: 'Edit page - ' + @page.try(:title)
  end

  def create
    @page = Page.new(page_params)
    @page.save
    respond_with(@page)
  end

  def update
    @page.update(page_params)
    respond_with(@page)
  end

  def destroy
    @page.destroy
    respond_with(@page)
  end

  private
    def set_page
      @page = Page.find(params[:id])
    end

    def page_params
      params.require(:page).permit(:title, :body, :image, :subsite_id, :activity_id, :published, :image, :remove_image, photos_attributes: [:image, :id,  :_destroy])
    end
end
