class Admin::PostsController < Admin::BaseController

  before_action :set_post, only: [:show, :edit, :update, :destroy]
  # skip_load_resource
  # load_and_authorize_resource
  respond_to :html
  has_scope :by_project
  has_scope :by_node

  def index
    order = sortable_column_order do |column, direction|
      case column
      when 'title'
        "#{column} #{direction}"
      when "created_at", "updated_at", "published", "posted_by"
        "#{column} #{direction}, title ASC"
      else
        "published_at DESC, title ASC"
      end
    end
    @posts = apply_scopes(Post).accessible_by(current_ability).order(order)
    # end
    @posts ||= apply_scopes(Post).accessible_by(current_ability).desc(:published_at)
    set_meta_tags title: 'Posts'
    respond_with(@posts)
  end

  def show
    redirect_to @post
  end

  def new
    @post = Post.new(node: @node)
    current_ability.attributes_for(:new, Post).each do |key, value|
      @post.send("#{key}=", value)
    end
    @post.user = current_user
    @post.attributes = params[:post]
    set_meta_tags title: 'New post'
    authorize! :new, @post

  end

  def edit
    set_meta_tags title: 'Edit post'
    authorize! :edit, @post
  end

  def create
    # @post = Post.new
    # current_ability.attributes_for(:create, Post).each do |key, value|
    #   @post.send("#{key}=", value)
    # end
    # @post.attributes = post_params
    #
    # authorize! :create, @post, :message => "Unable to create this post."
    @post = Post.new(post_params)
    if @post.save
      flash[:notice] = 'Post has been created.'
      redirect_to admin_posts_path
    end

  end

  def search
    if params[:searchterm].blank?
      redirect_to admin_posts_path
    else
      order = sortable_column_order do |column, direction|
        case column
        when 'title'
          "#{column} #{direction}"
        when "created_at", "updated_at", "published", "posted_by"
          "#{column} #{direction}, title ASC"
        else
          "published_at DESC, title ASC"
        end
      end
      @posts = [Post.full_text_search(params[:searchterm]), User.full_text_search(params[:searchterm]).map(&:posts), Project.full_text_search(params[:searchterm]).map(&:posts)].flatten.uniq.sort_by{|x| x.published_at.to_i }.reverse
      # end
      # @posts ||= apply_scopes(Post.search(params[:searchterm])).accessible_by(current_ability).desc(:published_at)
      set_meta_tags title: 'Posts'
      render :index
    end
  end

  def update
    if @post.update_attributes(post_params)
      flash[:notice] = 'post has been updated.'
      redirect_to admin_posts_path
    end

  end

  def destroy
    @post.destroy
    flash[:notice] = 'Post has been deleted.'
    redirect_to admin_posts_path

  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body, :sticky, :subsite_id, :short_abstract, :published, :user_id, :node_id, 
                                   :published_at, :hide_featured_image, :tags, :stay_id,
                                   photos_attributes: [:image, :id,  :_destroy],
                                   videos_attributes:  [:videofile, :id, :_destroy],
                                   activity_ids: [], postcategory_ids: [], project_ids: [] )
    end
end
