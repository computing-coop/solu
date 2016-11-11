class Admin::ParticipantsController < Admin::BaseController
  skip_load_resource :only => [:show, :destroy, :edit, :update, :destroy]
  handles_sortable_columns
  require 'csv'
  
  def create
    @symposium = Symposium.find(params[:symposium_id])
    @group = @symposium.groups.find(params[:group_id])
    @participant = @group.participants << Participant.new(participant_params)  
    if @symposium.save
      flash[:notice] = 'Participant added.'
    else
      flash[:error] = 'There was an error with adding the participant: ' + @symposium.errors.full_messages.join('; ')
    end
    redirect_to admin_symposium_groups_path(@symposium)
  end
  
  def destroy
    @symposium = Symposium.find(params[:symposium_id])
    @group = @symposium.groups.find(params[:group_id])
    @participant = @group.participants.find(params[:id])
    if @participant.delete
      flash[:notice] = 'The participant has been deleted.'
    end
    redirect_to admin_symposium_groups_path(@symposium)
  end
  
  def index
    @symposium = Symposium.find(params[:symposium_id])
    @group = @symposium.groups.find(params[:group_id])
    @participants = @group.participants

  end
      
  def edit
    @symposium = Symposium.find(params[:symposium_id])
    @group = @symposium.groups.find(params[:group_id])
    @participant = @group.participants.find(params[:id])
    set_meta_tags title: 'Edit participant : ' + @participant.name
  end
  
  def new
    @symposium = Symposium.find(params[:symposium_id])
    @group = @symposium.groups.find(params[:group_id])
    @participant = @group.participants.build #participants << Participant.new
    set_meta_tags title: @group.name + ": New participant"
  end
  
  def update
    @symposium = Symposium.find(params[:symposium_id])
    @group = @symposium.groups.find(params[:group_id])
    @participant = @group.participants.find(params[:id])  

    # hack because there appears to be a bug in mongoid!!!
    @participant.update(participant_params)   
    if @symposium.save
      flash[:notice] = 'The participant has been edited'
    else
      flash[:error] = 'The participant could not be edited : ' + @symposium.errors.full_messages
    end
    redirect_to admin_symposium_groups_path(@symposium)
  end
  
  protected
  
  def participant_params
    params.require(:participant).permit(:first_name, :avatar, :last_name, :website, :bio, :is_host, :accepted)
  end
  
end