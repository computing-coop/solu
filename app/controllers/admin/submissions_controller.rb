class Admin::SubmissionsController < Admin::BaseController
  skip_load_resource :only => [:show, :destroy]
  
  def destroy
    @call = Call.find(params[:call_id])
    @submission = @call.submissions.find(params[:id])
    @submission.destroy!
    redirect_to admin_call_submissions_path(@call)
  end
  
  def index
    @call = Call.find(params[:call_id])
    @submissions = @call.submissions
    set_meta_tags title: @call.name
  end

  def show
    @call = Call.find(params[:call_id])
    @submission = @call.submissions.find(params[:id])
    set_meta_tags title: @call.name + ": " + @submission.name
  end
  
end