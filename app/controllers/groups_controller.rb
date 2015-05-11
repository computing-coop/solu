class GroupsController < ApplicationController
  
  def index
    if @site.nil?
      redirect_to '/'
    else
      @groups = @site.symposium.groups.order(name: :asc)
      set_meta_tags title: @site.symposium.name + ": Groups"
      render layout: @site.layout
    end
  end
  
  def show
    if @site.nil?
      redirect_to '/'
    else
      @group = @site.symposium.groups.find(params[:id])
      set_meta_tags title: @site.symposium.name + ": " + @group.name
      render layout: @site.layout
    end
  end
      
end