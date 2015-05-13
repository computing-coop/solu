class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_filter :protect_with_staging_password if Rails.env.staging?
 
  before_filter :get_sticky_posts
  before_filter :configure_devise_params, if: :devise_controller?
  before_filter :check_subdomain
  before_filter :get_random_background
  
  def protect_with_staging_password
    authenticate_or_request_with_http_basic('Bioart eyes only! (for now)') do |username, password|
      username == Figaro.env.staging_username && password == Figaro.env.staging_password
    end
  end
    

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  protected
  
  def check_subdomain
    # get all possible subdomains
    sites = Subsite.all
    return if sites.empty?
    subdomains = sites.map(&:subdomain_list).flatten.uniq.compact
    fronturl = request.host.split(/\./).first
    if subdomains.include?(fronturl)
      @site = sites.delete_if{|x| x.subdomains !~ /#{fronturl}/ }.first
    end
    
  end
  
  def get_random_background
    if @site
      @background_image = Background.by_subsite(@site.id).active.skip(rand(Background.by_subsite(@site.id).active.count)).first
    else
      @background_image = Background.no_subsite.active.skip(rand(Background.no_subsite.active.count)).first
    end
  end
  
  def get_sticky_posts
    @sticky = Post.sticky.order(published_at: :desc).limit(2)    
  end
  
  def configure_devise_params
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:email,  :password, :remember_token, :remember_created_at, :sign_in_count, :partner_id) }
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:name, :partner_id, role_ids: [] )}    
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :partner_id, :password, :name,  :password_confirmation ) }
  end
    
end
