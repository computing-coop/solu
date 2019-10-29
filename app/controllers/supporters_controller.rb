class SupportersController < ApplicationController

  respond_to :html

  def index
    @supporters = Partner.where(is_general: true).order(name: :asc)
  end

end

