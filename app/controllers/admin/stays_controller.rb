class Admin::StaysController < Admin::BaseController
  skip_load_resource :only => [:show, :destroy, :edit, :update, :destroy]
  # before_action :set_stay, only: [:show, :edit, :destroy]
  before_action :get_artist

  respond_to :html

  def index
    @stays = Stay.all
    set_meta_tags title: 'Stays'
    respond_with(@stays)
  end

  def show
    redirect_to @stay
  end

  def new
    @stay = @artist.stays.build
    set_meta_tags title: 'New stay'
    respond_with @stay 
  end

  def edit
    @stay = @artist.stays.find(params[:id])
    set_meta_tags title: 'Edit stay - ' + @stay.try(:start_at).to_s
  end

  def create
    @stay = Stay.new(stay_params)
    @artist.stays << @stay
    @artist.save
    redirect_to admin_artists_path
  end

  def update
    @stay = @artist.stays.find(params[:id])
    @stay.update(stay_params)
    if @artist.save
      flash[:notice] = 'The stay has been edited'
    else
      flash[:error] = 'The stay could not be edited : ' + @artist.errors.inspect
    end
    redirect_to admin_artists_path
  end

  def destroy
    @stay.destroy
    respond_with @stay , location: admin_stays_path
  end

  private
    def set_stay
      @stay = Stay.find(params[:id])
    end

    def get_artist
      @artist = Artist.find(params[:artist_id])
    end

    def stay_params
      params.require(:stay).permit(:start_at, :end_at, :residency_description,
        photos_attributes: [:image, :id,  :_destroy])
    end
end
