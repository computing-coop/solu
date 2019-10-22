class Admin::UsersController < Admin::BaseController
  respond_to :html
  handles_sortable_columns

  def destroy
    @user = User.find(params[:id])
    @user.destroy!
    redirect_to admin_users_path
  end

  def edit
    @user = User.find(params[:id])
    set_meta_tags title: 'Edit user record'
  end

  def index
    order = sortable_column_order do |column, direction|
      case column
      when "name"
        "name #{direction}"

      else
        "name asc"
      end
    end
    @users = User.includes(:partner, :roles).order(order)
  end

  def update
    unless current_user.has_role? :god
      params[:user].delete([:role_ids])
    end
    unless current_user.has_role? :god
      params[:user].delete([:call_ids])
    end
    @user.update(user_params)
    flash[:notice] = 'Profile has been updated.'
    if can? :edit, User
      redirect_to admin_users_path
    else
      redirect_to '/admin'
    end
  end

  protected

  def user_params
     params.require(:user).permit(:name, :website, :biography, :avatar, :remove_avatar,  :partner_id, :email, role_ids: [] , call_ids: [])
  end

end
