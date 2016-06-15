class RegistrationMailer < ApplicationMailer
  default from: 'info@bioartsociety.fi'
  
  def registration_received(registration)
    @user = registration

    mail(to: registration.email, subject: 'HYBRID MATTERs symposium: registration received')
    
  end
  

end
