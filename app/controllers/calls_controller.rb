class CallsController < ApplicationController
  
  def show
    @call = Call.find(params[:id])
    @submission = Submission.new(call: @call)
    @call.questions.each do |qs|
      @submission.answers.build(question: qs)
    end
    set_meta_tags title: @call.name
  end
  
  
  def update
    @call = Call.find(params[:id])
    @submission = Submission.new(submission_params)
    @call.submissions << @submission
    if @call.save
      SubmissionMailer.submission_received(@submission).deliver
      flash[:notice] = 'Thank you for your submission.'
    else
      flash[:error] = 'There was an error with your submission: ' + @call.errors.full_messages.join('; ')
    end
    redirect_to @call
  end
    
  protected 
  
  def submission_params
    params[:call].require(:submission).permit(:first_name, :last_name, :address, :city, :country, :date_of_birth, :organisation_name, :nationality, :email, :website, answers_attributes: [:id, :question_id, :answer_text, :attachment, :answer_boolean ])
  end
  
end