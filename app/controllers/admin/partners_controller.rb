class Admin::PartnersController < Admin::BaseController
  before_action :set_admin_partner, only: [:show, :edit, :update, :destroy]
  
  respond_to :html

  def index
    @admin_partners = Partner.all
    respond_with(@admin_partners)
  end

  def show
    respond_with(@admin_partner)
  end

  def new
    @admin_partner = Partner.new
    respond_with(@admin_partner)
  end

  def edit
    @partner = Partner.find(params[:id])
  end

  def create
    @admin_partner = Partner.new(partner_params)
    @admin_partner.save
    respond_with(@admin_partner)
  end

  def update
    @admin_partner.update(partner_params)
    respond_with(@admin_partner)
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
      params.require(:partner).permit(:name, :website, :address1, :address2, :city, :country, :postcode, :latitude, :longitude, :logo, :description)
    end
end
