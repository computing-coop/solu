class CallsController < ApplicationController
  include ActionView::Helpers::TextHelper
  def apply
    @call = Call.find(params[:id])
    @submission = Submission.new(call: @call)
    @call.questions.sort_by(&:created_at).each do |qs|
      @submission.answers.build(question: qs)
    end
    if (@call.end_at.to_date.end_of_day.to_time.utc) < Time.current.utc
      if user_signed_in?
        unless current_user.has_role? :admin
          flash[:error] = "We're sorry, this open call has now closed."
          redirect_to @call
        end
      else
        flash[:error] = "We're sorry, this open call has now closed."
        redirect_to @call
      end
    end
    set_meta_tags title: @call.name
  end

  def show
    if params[:project_id]
      @project = Project.find(params[:project_id])
      @call = @project.calls.find(params[:id])
    else
      @call = Call.find(params[:id])
      if @call.project
        redirect_to project_call_url(@call.project, @call)
      end
    end

    @submission = Submission.new(call: @call)
    @call.questions.sort_by(&:created_at).each do |qs|
      @submission.answers.build(question: qs)
    end
    # @submission = Submission.new(call: @call)
    # @call.questions.each do |qs|
    #   @submission.answers.build(question: qs)
    # end

    set_meta_tags title: @call.name,
      og: { title: @call.name, type: 'article',
        url: url_for(@call),
        description: ActionView::Base.full_sanitizer.sanitize(truncate(strip_tags(@call.overview), length: 400)),
        image: @call.photos.empty? ? false : @call.photos.first.image.url(:box)
      },
      canonical: url_for(@call)
  end

  def thanks
  end

  def update
    @call = Call.find(params[:id])
    @submission = Submission.new(submission_params)
    @call.submissions << @submission
    if @call.save
      unless @call.end_at.to_date < Time.now.to_date
        if @call.node.name == 'bioart'
          SubmissionMailer.bioart_submission_received(@submission).deliver
        else
          SubmissionMailer.submission_received(@submission).deliver
        end
      end
      if @call.node.name == 'bioart'
        SubmissionMailer.submission_notification_to_bioart(@submission).deliver
        flash[:notice] = 'Thank you for your submission!'
        redirect_to '/'
      else
        SubmissionMailer.submission_notification_to_hm(@submission).deliver
        redirect_to thanks_calls_path
      end

    else
      flash[:error] = 'There was an error with your submission: ' + @call.errors.full_messages.join('; ')
    end

  end

  protected

  def submission_params
    params[:call].require(:submission).permit(:first_name,:short_biography,  :last_name, :address, :city, :country, :date_of_birth, :organisation_name, :nationality, :profession, :preferred_start, :preferred_end, :email, :website, answers_attributes: [:id, :question_id, :answer_text, :attachment, :answer_boolean ])
  end

end
