class ArtistsController < ApplicationController
  
  def show
    @artist = Artist.find(params[:id])
    set_meta_tags title: @artist.name
    render layout: @site.layout
  end
  
end