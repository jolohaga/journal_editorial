class StatesController < ApplicationController
  respond_to :html, :xml
  load_and_authorize_resource
  
  def index
    @submission = Submission.find(params[:submission_id])
    @editors = User.editors.order('LOWER(users.last_name), LOWER(users.first_name)')
    respond_with @states = @submission.states.created_at_desc
  end

  def show
    @state = State.find(params[:id])
    @submission = @state.stateful_entity
    respond_with @state
  end
  
  def new
    @state = State.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @state }
    end
  end
  
  def edit
    @state = State.find(params[:id])
    @submission = @state.stateful_entity
  end

  def create
    @submission = Submission.find(params[:submission_id])
    if @submission.next_state_recordable_date_range.include?(params[:state][:recorded_at].to_date)
      @submission.send(params[:state][:state].symbolize)
      @submission.reload
      @submission.current_state.update_attribute(:recorded_at, params[:state][:recorded_at].to_date)
      unless params[:editor].blank?
        if (params[:state][:state] == 'Adopt' || params[:state][:state] == 'Assign')
          assignment = @submission.assignments.build do |a|
            a.user = User.find(params[:editor])
            a.role = Role::ASSOCIATE_EDITOR
          end
          @submission.assignments << assignment
        end
      end
      flash[:notice] = 'Submission state successfully advanced!'
      if offer_folder_upload?
        flash[:step] = 'Step 2: '
        flash[:instructions] = 'Uploading documents'
        session[:return_to_state_management] = true
        respond_with @submission, :location => new_submission_folder_path(@submission)
      else
        respond_with @submission, :location => submission_states_path(@submission)
      end
    else
      flash[:notice] = 'Submission state date out of bounds!'
      respond_with @submission, :location => submission_states_path(@submission)
    end
  end
  
  def update
    @state = State.find(params[:id])
    @submission = @state.stateful_entity
    if @state.recordable_date_range.include?(params[:state][:recorded_at].to_date)
      @state.update_attributes(params[:state])
      flash[:notice] = "State was successfully updated!"
      respond_with @submission, :location => submission_states_path(@submission)
    else
      flash[:notice] = "State date out of bounds!"
      redirect_to edit_state_path(@state)
    end
  end
  
  def destroy
    @state = State.find(params[:id])
    @state.destroy

    respond_to do |format|
      format.html { redirect_to(states_url) }
      format.xml  { head :ok }
    end
  end
  
  def offer_folder_upload?
    state, prior_state = @submission.state, @submission.prior_state
    (['awaiting_review',
      'revising_under_prescreening',
      'rejected_under_prescreening',
      'withdrawn_under_prescreening',
      'pending_acceptance',
      'pending_rejection',
      'pending_acceptance_with_minor_modifications',
      'pending_revising',
      'withdrawn_under_review',
      'publishing',
      'revising_under_final_screening',
      'published'].include?(state) ||
     [['prescreening','revising_under_prescreening'],
      ['reviewing','revising_under_review'],
      ['reviewing','revising_with_minor_modifications'],
      ['final_screening','revising_under_final_screening']].include?([state,prior_state]))
  end
end