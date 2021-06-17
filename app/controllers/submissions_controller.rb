class SubmissionsController < ApplicationController
  
  def create
    @submission = Submission.new(submission_params)
    captcha_validated, captcha_response = verify_hcaptcha
    if captcha_validated && @submission.save
      flash[:notice] = 'Thank you for your submission.'
    else
      flash[:error] = 'There was an error with your submission: ' + @submission.errors.full_messages.join('; ')
    end
    redirect_to @submission.call
  end
  
  protected
  

  
end