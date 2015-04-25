class Admin::CommentsController < Admin::BaseController
    skip_load_resource :only => [:update, :edit, :destroy]
    
  def create
    @call = Call.find(params[:call_id])
    @submission = @call.submissions.find(params[:submission_id])
    @comment = @submission.comments << Comment.new(comment_params)
    if @submission.save
      flash[:notice] = 'Thank you for your thoughts.'
    else
      flash[:error] = 'There was an error with your comment: ' + @comment.errors.full_messages.join('; ')
    end
    redirect_to [:admin, @call, @submission]
  end
  
  def destroy
    @call = Call.find(params[:call_id])
    @submission = @call.submissions.find(params[:submission_id])
    @comment = @submission.comments.find(params[:id])
    if @comment.delete
      flash[:notice] = 'Your comment has been deleted.'
    end
    redirect_to [:admin, @call, @submission]
  end
  
  def edit
    @call = Call.find(params[:call_id])
    @submission = @call.submissions.find(params[:submission_id])
    @comment = @submission.comments.find(params[:id])
    set_meta_tags title: 'Edit comment'
  end
  
  
  def update
    @call = Call.find(params[:call_id])
    @submission = @call.submissions.find(params[:submission_id])
    @comment = @submission.comments.find(params[:id])
    # hack because there appears to be a bug in mongoid!!!
    @submission.comments.find(params[:id]).comment = comment_params["comment"]
    if @submission.save
      flash[:notice] = 'Your comment has been edited'
    else
      flash[:error] = 'Your comment could not be edited : ' + @call.errors.full_messages
    end

    redirect_to [:admin, @call, @submission]
  end
  
  protected
  
  def comment_params
    params.require(:comment).permit(:comment, :id, :user_id)
  end
end