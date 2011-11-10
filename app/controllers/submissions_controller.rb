class SubmissionsController < ApplicationController
  respond_to :html, :xml
  load_and_authorize_resource
  before_filter :set_paginate_filters, :only => :index
  
  def index
    session[:last_submissions_page] = params[:page]
    session[:last_filter_by] = params[:filter_by]
    if params[:filter_by] && (Submission.states.include?(params[:filter_by].symbolize) || Submission.respond_to?(params[:filter_by].symbolize))
      respond_with @submissions = Submission.send(params[:filter_by].symbolize).order("submissions.assignment_number #{@order}").paginate(@paginate_params)
    elsif params[:filter_by] == '(off)'
      redirect_to submissions_path
    else
      respond_with @submissions = Submission.order('submissions.assignment_number DESC').paginate(@paginate_params)
    end
  end
  
  def show
    @submission = Submission.includes(:folders).find(params[:id])
    @folders = @submission.folders.order('created_at DESC')
    respond_with @submission
  end
  
  def new
    flash[:step] = 'Step 1 of 2:'
    flash[:instructions] = ' Entering title, type and abstract of submission'
    respond_with @submission = Submission.new
  end
  
  def create
    @submission = Submission.new(params[:submission])
    @folder = Folder.new
    if @submission.submit
      @submission.reload
      unless params[:state].nil?
        @submission.current_state.update_attribute(:recorded_at, params[:state][:recorded_at])
      else
        @submission.current_state.update_attribute(:recorded_at, Date.today)
      end
      flash[:notice] = 'Submission successfully created!'
      flash[:step] = 'Step 2 of 2: '
      flash[:instructions] = 'Uploading documents'
      redirect_to new_submission_folder_path(@submission)
    else
      respond_with @submission
    end
  end
  
  def edit
    respond_with @submission = Submission.find(params[:id])
  end
  
  def update
    @submission = Submission.find(params[:id])
    if @submission.update_attributes(params[:submission])
      flash[:notice] = 'Submission successfully updated!'
    end
    respond_with @submission
  end
  
  def destroy
    @submission = Submission.find(params[:id])
    @submission.destroy
    flash[:notice] = 'Submission successfully destroyed!'
    respond_with @submission
  end
  
  def activity
    paginate_params = {:page => params[:page], :per_page => 4}
    if params[:submission]
      @submission = Submission.find(params[:submission])
      @header = "Activity for #{@submission.slug_display}"
      @activity = Observation.order('created_at DESC').find_all_by_submission_id(@submission).paginate(paginate_params)
    else
      @header = 'All activities'
      @activity = Observation.order('created_at DESC').paginate(paginate_params)
    end
  end
  
  def revert_state
    @submission = Submission.find(params[:id])
    @submission.revert_state!
    flash[:notice] = 'Submission state successfully reverted!'
    respond_with @submission, :location => submission_states_path(@submission)
  end
  
  def search
    unless params[:q].blank?
      @query = params[:q].downcase
      paginate_params = {:page => params[:page], :per_page => 8}
      query = "%#{@query}%"
      @submissions = Submission.where(["LOWER(submissions.title) LIKE ? OR LOWER(submissions.cached_slug) LIKE ?", query, query]).paginate(paginate_params)
      render :search_results
    else
      flash[:notice] = 'Search string is undefined.'
      redirect_to submissions_path
    end
  end
  
  def adopt
    submission = Submission.includes(:assignments).find(params[:id])
    if submission.editors.blank? && submission.awaiting_review? && current_user.associate_editor?
      submission.adopt
      submission.reload
      submission.current_state.update_attribute(:recorded_at, Date.today)
      assignment = Assignment.new do |a|
        a.user = current_user
        a.role = Role::ASSOCIATE_EDITOR
      end
      submission.assignments << assignment
      NotificationMailer.adopted_by_editor_notice(:submission => submission, :user => current_user).deliver
      flash[:notice] = "Submission has been successfully adopted by #{current_user.name} and email notices have been sent"
    else
      flash[:notice] = "This submission is not adoptable at this time!"
    end
    redirect_to submission
  end
  
  private
  def set_paginate_filters
     @paginate_params = {:page => params[:page]}
     if params[:per_page].is_numeric?
        @paginate_params[:per_page] = params[:per_page]
     else
        if params[:per_page] == 'all'
           @paginate_params[:per_page] = Submission.send(params[:filter_by].symbolize).count
        else
           @paginate_params[:per_page] = 8
        end
     end
     unless params[:order].nil?
        if ['ASC','DESC'].include?(params[:order].upcase)
           @order = params[:order]
        else
           @order = 'DESC'
        end
     else
        @order = 'DESC'
     end
  end
end