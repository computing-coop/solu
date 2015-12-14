class Admin::ArtistsController < Admin::BaseController
  
  before_action :set_artist, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @artists = Artist.all
    set_meta_tags title: 'Artists'
    respond_with(@artists)
  end

  def show
    redirect_to @artist
  end

  def new
    @artist = Artist.new
    set_meta_tags title: 'New artist'
    respond_with @artist 
  end

  def edit
    set_meta_tags title: 'Edit artist - ' + @artist.try(:name)
  end

  def create
    @artist = Artist.new(artist_params)
    @artist.save
    respond_with @artist, location: admin_artists_path
  end

  def update
    @artist.update(artist_params)
    respond_with @artist , location: admin_artists_path
  end

  def destroy
    @artist.destroy
    respond_with @artist , location: admin_artists_path
  end

  private
    def set_artist
      @artist = Artist.find(params[:id])
    end

    def artist_params
      params.require(:artist).permit(:name, :alphabetical_name, :bio, :country, :website, 
                                      photos_attributes: [:image, :id,  :_destroy])
    end
end
