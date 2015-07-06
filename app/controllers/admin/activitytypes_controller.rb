class Admin::ActivitytypesController < Admin::BaseController
  
  before_action :set_activitytype, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @activitytypes = Activitytype.order_by(:sort_order.asc)
    set_meta_tags title: 'Activity types'
    respond_with(@activitytypes)
  end
  
  def destroy
    @activitytype = Activitytype.find(params[:id])
    @activitytype.destroy!
    redirect_to admin_activitytypes_path
  end

  def sort
    @activitytypes = Activitytype.all
    @activitytypes.each do |fi|
      next if params['activitytype'].index(fi.id.to_s).nil?
      fi.sort_order = params['activitytype'].index(fi.id.to_s) + 1
      fi.save
    end
    render nothing: true  
  end
  
  def show
    redirect_to @activitytype
  end

  def new
    @activitytype = Activitytype.new
    set_meta_tags title: 'New activity type'
    respond_with(@activitytype)
  end

  def edit
    set_meta_tags title: 'Edit activity type - ' + @activitytype.try(:name)
  end

  def create
    @activitytype = Activitytype.new(activitytype_params)
    if @activitytype.save
      respond_to do |format|
        format.html { redirect_to admin_activitytypes_path, notice: 'Category was successfully created.' }
      end
    else
      flash[:error] = @activitytype.errors.full_messages
      set_meta_tags title: 'Error creating activity type'
      render :template => 'admin/activitytypes/edit'
    end
  end

  def update
    if @activitytype.update(activitytype_params)
      respond_to do |format|
        format.html { redirect_to admin_activitytypes_path, notice: 'Category was successfully created.' }
      end
    else
      flash[:error] = @activitytype.errors.full_messages
      set_meta_tags title: 'Error creating activity type'
      render :template => 'admin/activitytypes/edit'
    end
  end



  private
    def set_activitytype
      @activitytype = Activitytype.find(params[:id])
    end

    def activitytype_params
      params.require(:activitytype).permit(:name)
    end
end
