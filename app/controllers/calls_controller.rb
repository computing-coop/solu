class CallsController < ApplicationController
  
  def apply
    @call = Call.find(params[:id])
    @submission = Submission.new(call: @call)
    @call.questions.each do |qs|
      @submission.answers.build(question: qs)
    end
    if @call.end_at.to_date < Time.now.to_date
      if user_signed_in?
        unless current_user.has_role? :admin
          flash[:error] = "We're sorry, this open call has now closed."
          redirect_to @call
        end
      else
        flash[:error] = "We're sorry, this open call has now closed."
        redirect_to @call
      end
    end
    set_meta_tags title: @call.name
  end
  
  def show
    @call = Call.find(params[:id])
    # @submission = Submission.new(call: @call)
    # @call.questions.each do |qs|
    #   @submission.answers.build(question: qs)
    # end
    set_meta_tags title: @call.name
  end
  
  def thanks
  end
  
  def update
    @call = Call.find(params[:id])
    @submission = Submission.new(submission_params)
    @call.submissions << @submission
    if @call.save
      unless @call.end_at.to_date < Time.now.to_date
        SubmissionMailer.submission_received(@submission).deliver
      end
      SubmissionMailer.submission_notification_to_hm(@submission).deliver
      redirect_to thanks_calls_path
    else
      flash[:error] = 'There was an error with your submission: ' + @call.errors.full_messages.join('; ')
    end
    
  end
    
  protected 
  
  def submission_params
    params[:call].require(:submission).permit(:first_name,:short_biography,  :last_name, :address, :city, :country, :date_of_birth, :organisation_name, :nationality, :email, :website, answers_attributes: [:id, :question_id, :answer_text, :attachment, :answer_boolean ])
  end
  
end