class SubmissionMailer < ApplicationMailer
  default from: 'info@hybridmatters.net'
  
  def submission_received(submission)
    @user = submission

    mail(to: submission.email, subject: 'HYBRID MATTERs: Application received')
    
  end
end
