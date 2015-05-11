class Admin::GroupsController < Admin::BaseController
  
  def index
    @symposium = Symposium.find(params[:symposium_id])
    @groups = @symposium.groups
  end
    
  end