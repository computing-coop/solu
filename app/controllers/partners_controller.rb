class PartnersController < ApplicationController
  respond_to :html
  
  def index
    @partners = Partner.all
    set_meta_tags title: 'Partners'
    respond_with @partners
  end
  
  def show
    @partner = Partner.find(params[:id])
    set_meta_tags title: @partner.name
    respond_with @partner
  end
  
end