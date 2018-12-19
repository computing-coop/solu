class PartnersController < ApplicationController
  respond_to :html

  def index
    if @node.name =='bioart'
      redirect_to host: 'hybridmatters.net'
    else
      @partners = Partner.by_node(@node).sort_by(&:created_at)
      set_meta_tags title: 'Partners'
      respond_with @partners
    end
  end

  def show
    if @node.name == 'bioart'
      redirect_to host: 'hybridmatters.net'
    else 
      @partner = Partner.find(params[:id])
      set_meta_tags title: @partner.name
      respond_with @partner
    end
  end
end
