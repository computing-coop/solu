class Admin::BackgroundsController < Admin::BaseController


  def index
    @backgrounds = Background.all
    set_meta_tags title: 'Header images'
  end

  def show
    @background = Background.find(params[:id])
  end

  def new
    @background = Background.new
    set_meta_tags title: 'New header image'
  end

  def edit
    @background = Background.find(params[:id])
    set_meta_tags title: 'Edit header image'
  end

  def create
    
    @background = Background.new(background_params)

    respond_to do |format|
      if @background.save
        format.html { redirect_to admin_backgrounds_path, notice: 'Background was successfully created.' }
        format.json { render :show, status: :created, location: @background }
      else
        format.html { render :new }
        format.json { render json: @background.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @background = Background.find(params[:id])
    respond_to do |format|
      if @background.update(background_params)
        format.html { redirect_to admin_backgrounds_path, notice: 'Background was successfully updated.' }
        format.json { render :show, status: :ok, location: @background }
      else
        format.html { render :edit }
        format.json { render json: @background.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @background = Background.find(params[:id])
    @background.destroy
    respond_to do |format|
      format.html { redirect_to admin_backgrounds_path, notice: 'Background was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def background_params
      params.require(:background).permit(:regular, :credit, :subsite_id, :mobile, :active)
    end
    
end
