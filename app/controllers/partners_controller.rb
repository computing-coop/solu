class PartnersController < ApplicationController
  respond_to :html
  
  def show
    @partner = Partner.find(params[:id])
    set_meta_tags title: @partner.name
    respond_with @partner
  end
  
end