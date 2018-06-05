class ArtistsController < ApplicationController
  
  
  def index
    if @node.name == 'bioart'
      @artists = Artist.all.order(alphabetical_name: :asc)
      render template: 'residencies/index'
    else
      if @activity.nil?
        @artists = Artist.order(alphabetical_name: :asc)
        set_meta_tags title: "Artists"
       
      else
        @artists = @activity.works.map(&:artists).flatten.sort_by(&:alphabetical_name).uniq
        set_meta_tags title: @activity.name + ": Artists"

      end
      render layout: @site.layout
    end
  end
  
  
  def show
    @artist = Artist.find(params[:id])
    set_meta_tags title: @artist.name
    if @node.name == 'bioart'
      render template: 'residencies/show'
    else
      render layout: @site.layout
    end
  end
  
end