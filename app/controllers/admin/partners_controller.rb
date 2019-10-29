class Admin::PartnersController < Admin::BaseController
  before_action :set_admin_partner, only: [:show, :edit, :update, :destroy]
  handles_sortable_columns
  respond_to :html

  def index
    order = sortable_column_order do |column, direction|
      case column
      when 'name'
        "#{column} #{direction}"
      when 'funder'
        "is_general DESC, name ASC"
      when "created_at", "updated_at"
        "#{column} #{direction}, title ASC"
      else
        "updated_at DESC, name ASC"
      end
    end
    @admin_partners = apply_scopes(Partner).order(order)
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
    if @admin_partner.save
      redirect_to admin_partners_path
    else
      flash[:error] = 'error: ' + @admin_partner.errors.inspect
      respond_with(@admin_partner)
    end
  end

  def update
    if @admin_partner.update_attributes(partner_params)
      redirect_to admin_partners_path
    else
      flash[:error] = @admin_partner.errors.full_messages.join('; ')
      render template: 'admin/partners/edit'
    end
  end

  def destroy
    @admin_partner.destroy
    redirect_to admin_partners_path
  end

  private
    def set_admin_partner
      @admin_partner = Partner.find(params[:id])
    end

    def partner_params
      params.require(:partner).permit(:name, :website, :is_general, :start_year, :end_year, :address1, :css_colour, :address2, :city, :country, :is_funder,
      :postcode, :latitude, :longitude, :logo, :hmlogo, :remove_logo, :remove_hmlogo, :node_id, :description,
      photos_attributes:[:image, :id,  :_destroy],
       project_ids: [] )
    end
end
