class Admin::FrontitemsController <  Admin::BaseController
  skip_load_resource :only => [:show, :destroy, :edit, :update, :destroy]
  #before_action :set_frontitem, only: [:show, :edit, :update, :destroy]

  # GET /frontitems
  # GET /frontitems.json
  def index
    @frontitems = @node.frontitems
  end


  # GET /frontitems/new
  def new
    @frontitem = Frontitem.new
  end

  # GET /frontitems/1/edit
  def edit
    @frontitem = @node.frontitems.find(params[:id])
  end

  # POST /frontitems
  # POST /frontitems.json
  def create
    @frontitem = Frontitem.new(frontitem_params)
    @frontitem.node = @node
    respond_to do |format|
      if @frontitem.save
        format.html { redirect_to admin_frontitems_path, notice: 'Frontitem was successfully created.' }
        format.json { render :show, status: :created, location: @frontitem }
      else
        format.html { render :new }
        format.json { render json: @frontitem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /frontitems/1
  # PATCH/PUT /frontitems/1.json
  def update
    @frontitem = @node.frontitems.find(params[:id])
    respond_to do |format|
      if @frontitem.update(frontitem_params)
        format.html { redirect_to admin_frontitems_path, notice: 'Frontitem was successfully updated.' }
        format.json { render :show, status: :ok, location: @frontitem }
      else
        format.html { render :edit }
        format.json { render json: @frontitem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /frontitems/1
  # DELETE /frontitems/1.json
  def destroy
    @frontitem = @node.frontitems.find(params[:id])
    @frontitem.destroy
    respond_to do |format|
      format.html { redirect_to admin_frontitems_url, notice: 'Frontitem was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private


    # Never trust parameters from the scary internet, only allow the white list through.
    def frontitem_params
      params.require(:frontitem).permit(:item_id, :item_type, :wideimage, :wideimage_width, :wideimage_height, :wideimage_content_type, :smallblurb_background_colour, :smallblurb_text_colour, :smallblurb_hover_colour, :smallblurb_text, :middleblurb_background_color, :middleblurb_text_colour, :middleblurb_hover_colour, :middleblurb_text, :thirdblurb_background_colour, :thirdblurb_text_colour, :thirdblurb_hover_colour, :thirdblurb_text, :url_override, :node_id, :published, :sortorder, :no_text, :dont_scale)
    end
end
