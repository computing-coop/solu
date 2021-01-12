class SubmissionsController < ApplicationController
  
  def create
    @submission = Submission.new(submission_params)
    if verify_recaptcha(model: @submission) && @submission.save
      flash[:notice] = 'Thank you for your submission.'
    else
      flash[:error] = 'There was an error with your submission: ' + @submission.errors.full_messages.join('; ')
    end
    redirect_to @submission.call
  end
  
  protected
  

  
end