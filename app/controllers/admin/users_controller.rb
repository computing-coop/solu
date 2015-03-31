class Admin::UsersController < Admin::BaseController
  respond_to :html
    
  def edit
    @user = User.find(params[:id])
    set_meta_tags title: 'Edit user record'
  end
  
  def index
    @users = User.all
  end
  
  def update
    @user.update(user_params)
    respond_with([:admin, @user])
  end

  protected
  
  def user_params
     params.require(:user).permit(:name, :website, :biography, :partner_id, :email)
  end
  
end
