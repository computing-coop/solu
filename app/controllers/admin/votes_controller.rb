class Admin::VotesController < Admin::BaseController
  
  def create
    @call = Call.find(params[:call_id])
    @submission = @call.submissions.find(params[:submission_id])
    @vote = @submission.votes << Vote.new(vote_params)

    if @submission.save
      flash[:notice] = 'Thank you for your thoughts.'
    else
      flash[:error] = 'There was an error with your vote: ' + @vote.errors.full_messages.join('; ')
    end
    redirect_to [:admin, @call, @submission]
  end
  
  protected
  
  def vote_params
    params.require(:vote).permit(:vote, :user_id)
  end
end