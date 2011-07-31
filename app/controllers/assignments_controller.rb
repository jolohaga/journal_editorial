class AssignmentsController < ApplicationController
  respond_to :html, :xml
  load_and_authorize_resource
  after_filter :find_or_create_assigned_role_association, :only => [:create]
  
  def index
    @submission = Submission.includes(:assignments).find(params[:submission_id])
    @assignment = Assignment.new
    respond_with @assignments = @submission.assignments
  end
  
  def create
    @submission = Submission.includes(:assignments).find(params[:submission_id])
    @assignment = Assignment.new(params[:assignment])
    @submission.assignments << @assignment
    flash[:notice] = 'Person successfully assigned!'
    @assignments = @submission.assignments
    respond_with @assignments, :location => submission_assignments_path(@submission)
  end
  
  def destroy
    @assignment = Assignment.includes(:submission).find(params[:id])
    @submission = @assignment.submission
    @assignment.destroy
    flash[:notice] = 'Person successfully unassigned!'
    respond_with @submission, :location => submission_assignments_path(@submission)
  end
  
  def find_or_create_assigned_role_association
    user = @assignment.user
    unless user.roles.find_by_name(@assignment.role)
      user.roles << Role.find_by_name(@assignment.role)
    end
  end
end