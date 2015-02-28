class HomeController < ApplicationController
  
  def index
    @call = Call.first
    redirect_to @call
  end
  
end
