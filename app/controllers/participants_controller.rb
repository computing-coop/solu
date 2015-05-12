class ParticipantsController < ApplicationController
  
  def index
    if @site.nil?
      redirect_to '/'
    else
      @participants = @site.symposium.groups.map{|x| x.participants.approved }.flatten.sort_by{|x| x.last_name.strip }
      set_meta_tags title: @site.symposium.name + ": Participants"
      render layout: @site.layout
    end
  end
  
end