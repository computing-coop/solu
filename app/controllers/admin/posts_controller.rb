class Admin::PostsController < Admin::BaseController

  before_action :set_post, only: [:show, :edit, :update, :destroy]

  respond_to :html
  has_scope :by_project
  has_scope :by_node
  
  

  def index
    sortable_column_order do |column, direction|
      @posts = apply_scopes(Post) #.sort_by(column, direction)
    end
    @posts ||= apply_scopes(Post).desc(:published_at)
    set_meta_tags title: 'Posts'
    respond_with(@posts)
  end

  def show
    redirect_to @post
  end

  def new
    @post = Post.new
    set_meta_tags title: 'New post'
    respond_with(@post)
  end

  def edit
    set_meta_tags title: 'Edit post'
  end

  def create
    @post = Post.new(post_params)
    @post.save
    respond_with(@post)
  end

  def update
    @post.update(post_params)
    redirect_to admin_posts_path
  end

  def destroy
    @post.destroy
    respond_with(@post)
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body, :sticky, :subsite_id, :short_abstract, :published, :user_id, :node_id, :project_id,
                                   :published_at, :hide_featured_image, :tags,
                                   photos_attributes: [:image, :id,  :_destroy], 
                                   videos_attributes:  [:videofile, :id, :_destroy],
                                   activity_ids: [], postcategory_ids: [] )
    end
end
