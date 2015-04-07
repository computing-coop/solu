class Admin::CommentsController < Admin::BaseController
  
  def create
    @call = Call.find(params[:call_id])
    @submission = @call.submissions.find(params[:submission_id])
    @comment = @submission.comments << Comment.new(comment_params)
    if @submission.save
      flash[:notice] = 'Thank you for your thoughts..'
    else
      flash[:error] = 'There was an error with your comment: ' + @comment.errors.full_messages.join('; ')
    end
    redirect_to [:admin, @call, @submission]
  end
  
  protected
  
  def comment_params
    params.require(:comment).permit(:comment, :user_id)
  end
end