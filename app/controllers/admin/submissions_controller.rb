class Admin::SubmissionsController < Admin::BaseController
  skip_load_resource :only => :show
  
  def index
    @call = Call.find(params[:call_id])
    @submissions = @call.submissions
  end

  def show
    @call = Call.find(params[:call_id])
    @submission = @call.submissions.find(params[:id])
  end
  
end