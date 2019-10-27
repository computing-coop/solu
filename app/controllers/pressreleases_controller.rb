class PressreleasesController < ApplicationController

  respond_to :html

  def index
    @pressreleases = Pressrelease.published.order(date: :desc)
    render template: 'pages/media'
  end

  def show
    @pressrelease = Pressrelease.find(params[:id])
    if @pressrelease.published
      render template: 'pages/pressrelease'
    else
      if current_user && can?(:edit, @pressrelease)
        render template: 'pages/pressrelease'
      else
        flash[:error] = 'You cannot do this.'
        redirect_to pressreleases_path
      end
    end
  end
end

