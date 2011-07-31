class AssociatesController < ApplicationController
  respond_to :html, :xml
  load_and_authorize_resource :user
  
  def index
    @associates = User.associates.order('users.name').paginate(:page => params[:page], :per_page => 8)
  end
  
  def show
    @associate = User.find(params[:id])
    @assignments = @associate.assignments
  end
  
  def new
    @submission = Submission.find(params[:submission_id]) unless params[:submission_id].nil?
    respond_with @associate = User.new(:password => Journal::Users::DEFAULT_ASSOCIATE_PASSWORD)
  end
  
  def create
    @associate = User.new(params[:user])
    @associate.roles << Role.find_by_name(params[:role][:name])
    unless params[:submission_id].nil?
      @submission = Submission.find(params[:submission_id])
      @submission.assignments.build do |a|
        a.role = params[:role][:name]
        a.user = @associate
      end
      if @submission.save
        flash[:notice] = "Associate successfully created and assigned!"
      end
      respond_with @associate, :location => submission_assignments_path(@submission)
    else
      if @associate.save
        flash[:notice] = "Associate successfully created!"
      end
      respond_with @associate, :location => associate_path(@associate)
    end
  end
  
  def edit
    
  end
  
  def update
    
  end
end