class Admin::SymposiaController < Admin::BaseController
  
  before_action :set_symposium, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @symposia = Symposium.all
    set_meta_tags title: 'Symposiums'
    respond_with @symposia, location: admin_symposia_path
  end

  def show
    redirect_to @symposium
  end

  def new
    @symposium = Symposium.new
    set_meta_tags title: 'New symposium'
    respond_with(@symposium)
  end

  def edit
    set_meta_tags title: 'Edit symposium - ' + @symposium.try(:name)
  end

  def create
    @symposium = Symposium.new(symposium_params)
    @symposium.save
    respond_with @symposia, location: admin_symposia_path
  end

  def update
    @symposium.update(symposium_params)
    respond_with @symposia, location: admin_symposia_path
  end

  def destroy
    @symposium.destroy
    respond_with @symposia, location: admin_symposia_path
  end

  private
    def set_symposium
      @symposium = Symposium.find(params[:id])
    end

    def symposium_params
      params.require(:symposium).permit(:name, :start_at, :end_at, :location, :location_url, groups_attributes: [:id, :_destroy, :name, :host, :host_url, :short_description, :description])
    end
    
    
end
