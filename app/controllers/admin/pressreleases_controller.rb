class Admin::PressreleasesController < Admin::BaseController

  respond_to :html
  handles_sortable_columns

  def index
    order = sortable_column_order do |column, direction|
      case column
      when 'title'
        "#{column} #{direction}"
      when "created_at", "updated_at"
        "#{column} #{direction}, title ASC"
      when "published"
        "published #{direction}"
      else
        "updated_at DESC, title ASC"
      end
    end
    @pressreleases = apply_scopes(Pressrelease).order(order)
    set_meta_tags title: 'Press releases'
    respond_with(@pressreleases)
  end


  def show
    @pressrelease = Pressrelease.find(params[:id])
    redirect_to @pressrelease
  end

  def new
    @pressrelease = Pressrelease.new
    set_meta_tags title: 'New press release'
    respond_with(@pressrelease)
  end

  def edit
    @pressrelease = Pressrelease.find(params[:id])
    set_meta_tags title: 'Edit press release - ' + @pressrelease.try(:title)
  end

  def create

    @pressrelease = Pressrelease.new(pressrelease_params)
    if @pressrelease.save
      redirect_to admin_pressreleases_path
    else
      render template: 'admin/pressreleases/new', status: 422
    end
  end

  def update
    @pressrelease = Pressrelease.find(params[:id])
    @pressrelease.update(pressrelease_params)
    redirect_to admin_pressreleases_path
  end

  def destroy
    @pressrelease.destroy
    redirect_to admin_pressreleases_path
  end

  private
    def set_page
      @pressrelease = Pressrelease.find(params[:id])
    end

    def pressrelease_params
      params.require(:pressrelease).permit(:title, :body, :attachment, :image, :remove_attachment, :remove_image, :published, :published_at)
    end
end
