class ArtistsController < ApplicationController
  
  
  def index

    if @activity.nil?
      @artists = Artist.order(alphabetical_name: :asc)
      set_meta_tags title: "Artists"
     
    else
      @artists = @activity.works.map(&:artists).flatten.sort_by(&:alphabetical_name).uniq
      set_meta_tags title: @activity.name + ": Artists"

    end
    render layout: @site.layout
  end
  
  
  def show
    @artist = Artist.find(params[:id])
    set_meta_tags title: @artist.name
    render layout: @site.layout
  end
  
end