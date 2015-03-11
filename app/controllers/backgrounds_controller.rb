class BackgroundsController < ApplicationController
  before_action :set_background, only: [:show]

  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_background
      @background = Background.find(params[:id])
    end


end
