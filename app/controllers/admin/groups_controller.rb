class Admin::GroupsController < Admin::BaseController
  
  def index
    @symposium = Symposium.find(params[:symposium_id])
    @groups = @symposium.groups
    set_meta_tags title: @symposium.name + ": Groups"
  end
    
  end