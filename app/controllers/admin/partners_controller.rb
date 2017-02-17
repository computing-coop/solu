class Admin::PartnersController < Admin::BaseController
  before_action :set_admin_partner, only: [:show, :edit, :update, :destroy]
  
  respond_to :html

  def index
    @admin_partners = Partner.all
    set_meta_tags title: 'Partners'
    respond_with(@admin_partners)
  end

  def show
    respond_with(@admin_partner)
  end

  def new
    @admin_partner = Partner.new
    set_meta_tags title: 'New partner'
    respond_with(@admin_partner)
  end

  def edit
    @partner = Partner.find(params[:id])
    set_meta_tags title: 'Edit partner'
  end

  def create
    @admin_partner = Partner.new(partner_params)
    @admin_partner.save
    respond_with(@admin_partner)
  end

  def update
    @admin_partner.update_attributes(partner_params)
    redirect_to admin_partners_path
  end

  def destroy
    @admin_partner.destroy
    respond_with(@admin_partner)
  end

  private
    def set_admin_partner
      @admin_partner = Partner.find(params[:id])
    end

    def partner_params
      params.require(:partner).permit(:name, :website, :address1, :css_colour, :address2, :city, :country, 
      :postcode, :latitude, :longitude, :logo, :hmlogo, :remove_logo, :remove_hmlogo, :description,
      photos_attributes:[:image, :id,  :_destroy],
       project_ids: [] )
    end
end
