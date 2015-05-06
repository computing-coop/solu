class Admin::SubsitesController < Admin::BaseController
  
  before_action :set_subsite, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @subsites = Subsite.all
    set_meta_tags title: 'Subsites'
    respond_with @subsites, location: admin_subsites_path
  end

  def show
    redirect_to @subsite
  end

  def new
    @subsite = Subsite.new
    set_meta_tags title: 'New subsite'
    respond_with(@subsite)
  end

  def edit
    set_meta_tags title: 'Edit subsite - ' + @subsite.try(:name)
  end

  def create
    @subsite = Subsite.new(subsite_params)
    @subsite.save
    respond_with @subsites, location: admin_subsites_path
  end

  def update
    @subsite.update(subsite_params)
    respond_with @subsites, location: admin_subsites_path
  end

  def destroy
    @subsite.destroy
    respond_with @subsites, location: admin_subsites_path
  end

  private
    def set_subsite
      @subsite = Subsite.find(params[:id])
    end

    def subsite_params
      params.require(:subsite).permit(:name, :subdomains)
    end
    
    
end
