class SupportersController < ApplicationController

  respond_to :html

  def index
    @supporters = Partner.where(is_general: true).order(sort_order: :asc, name: :asc)
  end

end

