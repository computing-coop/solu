class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token, if: -> { controller_name == 'sessions' && action_name == 'create' }
  before_filter :protect_with_staging_password if Rails.env.staging?
 
  before_filter :get_sticky_posts
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :check_subdomain
  before_filter :get_random_background
  
  def protect_with_staging_password
    authenticate_or_request_with_http_basic('Bioart eyes only! (for now)') do |username, password|
      username == Figaro.env.staging_username && password == Figaro.env.staging_password
    end
  end
    
  rescue_from ActionController::InvalidAuthenticityToken do |exception|
    redirect_to root_path, :alert => exception.message
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
      
      if @site.name == 'Exhibitions'

        case params[:place]
         when "grenland"

          exhibitions = Partner.find('kunsthall-grenland').activities_leading.delete_if{|x| x.activity_type != 'exhibition' }
          unless exhibitions.empty?
            @activity = exhibitions.first
          end
        when "nikolaj"
          exhibitions = Partner.find('nikolaj-kunsthal').activities_leading.delete_if{|x| x.activity_type != 'exhibition' }
          unless exhibitions.empty?
            @activity = exhibitions.first
          end
        when "forumbox"
          exhibitions = Partner.find('forum-box').activities_leading.delete_if{|x| x.activity_type != 'exhibition' }
          unless exhibitions.empty?
            @activity = exhibitions.first
          end
        end
      
      end
      
    end
        
    
  end
  
  def get_random_background
    if @site
      @background_image = Background.by_subsite(@site.id).active.skip(rand(Background.by_subsite(@site.id).active.count)).first
    else
      @background_image = Background.active.skip(rand(Background.active.count)).first
    end
  end
  
  def get_sticky_posts
    @sticky = Post.sticky.order(published_at: :desc).limit(2)    
  end
  
  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me, :remember_token, :remember_created_at, :sign_in_count, :partner_id,  role_ids: [] ]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs

  end

    
end
