class Admin::CallsController < Admin::BaseController
  
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @calls = Call.all
    set_meta_tags title: 'Open calls'
    respond_with(@calls)
  end

  def show
    set_meta_tags title: @call.name
    redirect_to @call
  end

  def new
    @call = Call.new
    respond_with(@call)
  end

  def edit
  end

  def create
    @call = Call.new(call_params)
    @call.save
    respond_with(@call)
  end

  def update
    @call.update(call_params)
    respond_with(@call)
  end

  def destroy
    @call.destroy
    redirect_to admin_calls_path
  end

  private
    def set_page
      @call = Call.find(params[:id])
    end

    def call_params
      params.require(:call).permit(:name, :overview, :node_id,  :project_id, :start_at, :symposium_id, :end_at, :published, photos_attributes: [:image, :id,  :_destroy], questions_attributes: [:id, :question, :hint, :question_type, :char_limit, :required, :_destroy])
    end
end
