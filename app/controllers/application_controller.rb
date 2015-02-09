class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email, :password, :remember_token, :remember_created_at, :sign_in_count) }
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:name, role_ids: [] )}    
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :name,  :password_confirmation ) }
  end
    
end
