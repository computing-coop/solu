class Admin::ParticipantsController < Admin::BaseController
  skip_load_resource :only => [:show, :destroy]
  handles_sortable_columns
  
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
  
  def new
    @symposium = Symposium.find(params[:symposium_id])
    @group = @symposium.groups.find(params[:group_id])
    @participant = @group.participants.build #participants << Participant.new
    
  end
  
  protected
  
  def participant_params
    params.require(:participant).permit(:first_name, :avatar, :last_name, :bio, :is_host, :approved)
  end
  
end