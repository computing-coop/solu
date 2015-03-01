class SubmissionMailer < ApplicationMailer
  default from: 'info@hybridmatters.net'
  
  def submission_received(submission)
    @user = submission

    mail(to: submission.email, subject: 'HYBRID MATTERs: Application received')
    
  end
  
  def submission_notification_to_hm(submission)
    @user = submission

    mail(to: 'info@hybirdmatters.net', cc: 'eb@randomseed.org', subject: 'HYBRID MATTERs: Application submitted')
    
  end
  
end
