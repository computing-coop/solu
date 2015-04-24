class Admin::VotesController < Admin::BaseController
  skip_load_resource :only => [:update]
  
  def create
    @call = Call.find(params[:call_id])
    @submission = @call.submissions.find(params[:submission_id])
    @vote = @submission.votes << Vote.new(vote_params)

    if @call.save
      flash[:notice] = 'Thank you for your thoughts.'
    else
      flash[:error] = 'There was an error with your vote: ' + @vote.errors.full_messages.join('; ')
    end
    redirect_to [:admin, @call, @submission]
  end
  
  
  def update

    @call = Call.find(params[:call_id])
    @submission = @call.submissions.find(params[:submission_id])
    # @submission.votes = @submission.votes.delete_if{|x| x.user == current_user }
    @vote = @submission.votes.find(params[:id])
    
    @vote.vote = params[:vote].permit(:vote)[:vote]

    if @call.save
      flash[:notice] = 'Thank you for your thoughts.'
    else
      flash[:error] = 'There was an error with changing your vote: ' + @call.errors.full_messages.join('; ')
    end
    redirect_to [:admin, @call, @submission]
  end
  
  protected
  
  def vote_params
    params.require(:vote).permit(:vote, :user_id)
  end
end