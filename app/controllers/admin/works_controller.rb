class Admin::WorksController < Admin::BaseController
  
  before_action :set_work, only: [:show, :edit, :destroy]

  respond_to :html

  def index
    @works = Work.all
    set_meta_tags title: 'Works'
    respond_with(@works)
  end

  def show
    redirect_to @work
  end

  def new
    @work = Work.new
    set_meta_tags title: 'New work'
    respond_with @work 
  end

  def edit
    set_meta_tags title: 'Edit work - ' + @work.try(:title)
  end

  def create
    @work = Work.new(work_params)
    @work.save
    respond_with @work, location: admin_works_path
  end

  def update
    @work = Work.find(params[:id])
    @work.update(work_params)
    respond_with @work , location: admin_works_path
  end

  def destroy
    @work.destroy
    respond_with @work , location: admin_works_path
  end

  private
    def set_work
      @work = Work.find(params[:id])
    end

    def work_params
      params.require(:work).permit(:title, :description,  :artist_id,  
                                      photos_attributes: [:image, :id,  :_destroy], activity_ids: [])
    end
end
