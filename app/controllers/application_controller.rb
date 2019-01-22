class ApplicationController < ActionController::Base
  include ThemesForRails::UrlHelpers

  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: -> { controller_name == 'sessions' && action_name == 'create' }
  before_action :protect_with_staging_password if Rails.env.staging?
 
  before_action :get_sticky_posts
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :check_subdomain
  before_action :get_random_background
  theme :get_node
  
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
  
  def get_node
    # if Rails.env.development?
      if request.host =~ /bioartsociety/ || request.host =~ /solu\.earth/
        @node = Node.find_by(name: 'bioart')
      else
        @node = Node.find_by(name: 'hybrid_matters')
      end
      @node.name
   end
  
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
    added_attrs = [:username, :email, :name, :password, :password_confirmation, :remember_me, :remember_token, :remember_created_at, :sign_in_count, :partner_id,  role_ids: [] ]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs

  end

    
end
