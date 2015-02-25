class Admin::BaseController < ApplicationController

  before_filter :authenticate_user!
  layout 'admin'
  check_authorization
  
  skip_before_filter :require_no_authentication
  load_and_authorize_resource
 
  def check_permissions
    authorize! :create, resource
  end
  
end
