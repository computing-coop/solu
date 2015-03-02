class SubmissionMailer < ApplicationMailer
  default from: 'info@bioartsociety.fi'
  
  def submission_received(submission)
    @user = submission

    mail(to: submission.email, subject: 'HYBRID MATTERs: Application received')
    
  end
  
  def submission_notification_to_hm(submission)
    @user = submission

    mail(to: 'info@bioartsociety.fi', subject: 'HYBRID MATTERs: Application submitted')
    
  end
  
end
