class RegistrationsController < ApplicationController
  
  def new
    if @site.nil?
      redirect_to '/'
    else
      @participant = Participant.new
      @participant.build_symposium_registration
      set_meta_tags title: @site.symposium.name + ": Registration"
      render layout: @site.layout
    end
  end
  
end