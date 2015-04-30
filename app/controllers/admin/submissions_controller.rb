class Admin::SubmissionsController < Admin::BaseController
  skip_load_resource :only => [:show, :destroy]
  handles_sortable_columns
  
  def destroy
    @call = Call.find(params[:call_id])
    @submission = @call.submissions.find(params[:id])
    @submission.destroy!
    redirect_to admin_call_submissions_path(@call)
  end
  
  def index
    order = sortable_column_order do |column, direction|
      case column
      when "received"
        "created_at #{direction}"
      when "vote_average"
        "vote_average #{direction}"
      when "submitted_by"
        "last_name #{direction}"
      end
    end
    @call = Call.find(params[:call_id])
    @submissions = @call.submissions.order(order)
    set_meta_tags title: @call.name
  end

  def show
    @call = Call.find(params[:call_id])
    @submission = @call.submissions.find(params[:id])

    begin
      @vote = @submission.votes.find_by(user: current_user)
    rescue

      @vote = @submission.votes.build(user: current_user)
    end

    set_meta_tags title: @call.name + ": " + @submission.name
  end

end