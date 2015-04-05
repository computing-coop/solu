class Admin::PostsController < Admin::BaseController
  
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @posts = Post.all
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
    respond_with(@post)
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
      params.require(:post).permit(:title, :body,  :published, :user_id, :published_at, photos_attributes: [:image, :id,  :_destroy], activity_ids: [], postcategory_ids: [] )
    end
end
