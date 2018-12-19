class ParticipantsController < ApplicationController
 
  def create
    if @site.nil?
      redirect_to '/'
    else
      @participant = Participant.new(participant_params)
      if @site.name == 'Symposium'
        @participant.group = @site.symposium.groups.find_by(name: 'Public')
      end
      if verify_recaptcha(model: @participant) && @participant.save
        RegistrationMailer.registration_received(@participant).deliver
        flash[:notice] = 'Thank you for your registration. You should receive a confirmation email.'
        render template: 'registrations/registration_received', layout: 'symposium'
      else
        flash[:error] = @participant.errors.full_messages.join(", ")
        render layout: 'symposium', template: 'registrations/new'
      end
    end
  end

  def index
    if @site.nil?
      redirect_to '/'
    elsif @site.symposium.nil?
      redirect_to 'https://hybridmatters.net/'
    else
      @participants = @site.symposium.groups.map{|x| x.participants.approved }.flatten.sort_by{|x| x.last_name.strip }.to_a.delete_if{|x| x.group.name == 'Public'}
      set_meta_tags title: @site.symposium.name + ": Participants"
      render layout: @site.layout
    end
  end
  
  protected
  
  def participant_params
    params[:participant].permit(:first_name, :last_name, :email, :website, :bio, symposium_registration_attributes: [:keynote, :symposium, :dinner])
  end
  
end