class Admin::PostcategoriesController < Admin::BaseController
  
  before_action :set_postcategory, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @postcategories = Postcategory.all
    set_meta_tags title: 'Post categories'
    respond_with(@postcategories)
  end

  def show
    redirect_to @postcategory
  end

  def new
    @postcategory = Postcategory.new
    set_meta_tags title: 'New post category'
    respond_with(@postcategory)
  end

  def edit
    set_meta_tags title: 'Edit post category - ' + @postcategory.try(:name)
  end

  def create
    @postcategory = Postcategory.new(postcategory_params)
    if @postcategory.save
      respond_to do |format|
        format.html { redirect_to admin_postcategories_path, notice: 'Category was successfully created.' }
      end
    else
      flash[:error] = @postcategory.errors.full_messages
      set_meta_tags title: 'Error creating post category'
      render :template => 'admin/postcategories/edit'
    end
  end

  def update
    if @postcategory.update(postcategory_params)
      respond_to do |format|
        format.html { redirect_to admin_postcategories_path, notice: 'Category was successfully created.' }
      end
    else
      flash[:error] = @postcategory.errors.full_messages
      set_meta_tags title: 'Error creating post category'
      render :template => 'admin/postcategories/edit'
    end
  end

  def destroy
    @postcategory.destroy
    respond_with(@postcategory)
  end

  private
    def set_postcategory
      @postcategory = Postcategory.find(params[:id])
    end

    def postcategory_params
      params.require(:postcategory).permit(:name, :project_id)
    end
end
