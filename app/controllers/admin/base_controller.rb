class Admin::BaseController < ApplicationController
  handles_sortable_columns do |conf|
    conf.sort_param = "sort_by"
  end
  before_filter :authenticate_user!
  layout 'admin'
  check_authorization
  
  skip_before_filter :require_no_authentication
  load_and_authorize_resource
 
  def check_permissions
    authorize! :create, resource
  end
  
end
