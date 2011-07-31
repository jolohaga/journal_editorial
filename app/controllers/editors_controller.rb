class EditorsController < ApplicationController
  respond_to :html, :xml
  load_and_authorize_resource :class => 'User'
  
  def index
    session[:last_editors_page] = params[:page]
    @associates = User.editors.includes(:assignments,:specializations).order('LOWER(users.last_name), LOWER(users.first_name)').paginate(:page => params[:page], :per_page => 6)
  end
  
  def show
    @associate = User.includes(:responsibilities,:specializations).find(params[:id])
    @specializations = @associate.specializations.order('category,name')
    @active_assignments = @associate.responsibilities.active_under_review
    @published_assignments = @associate.responsibilities.reviewed_and_under_publication
    @removed_assignments = @associate.responsibilities.reviewed_and_under_removal
  end
  
  def new
    @submission = Submission.find(params[:submission_id]) unless params[:submission_id].nil?
    respond_with @associate = User.new(:password => Journal::Users::DEFAULT_ASSOCIATE_PASSWORD)
  end
  
  def create
    @associate = User.new(params[:user])
    @associate.roles << Role.find_by_name(Role::ASSOCIATE_EDITOR)
    if @associate.save
      flash[:notice] = 'Editor successfully created.'
    end
    if @associate.valid?
      respond_with @associate, :location => editor_path(@associate)
    else
      respond_with @associate
    end
  end
  
  def edit
    @associate = User.includes(:assignments).find(params[:id])
  end
  
  def update
    @associate = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank? # Ignore password if blank.
    if @associate.update_attributes(params[:user])
      flash[:notice] = "Successfully updated editor."
    end
    respond_with @associate, :location => editor_path(@associate)
  end
  
  def search
    unless params[:q].blank?
      @query = params[:q].downcase
      paginate_params = {:page => params[:page], :per_page => 8}
      query = "%#{@query}%"
      @editors = User.find_by_sql(["SELECT DISTINCT ON(id) users.*
        FROM users,specializations,specializations_users
        WHERE users.id = specializations_users.user_id
        AND specializations.id = specializations_users.specialization_id
        AND LOWER(specializations.name) LIKE ?", query]).paginate(paginate_params)
      render :search_results
    else
      flash[:notice] = 'Search string is undefined.'
      redirect_to editors_path
    end
  end
end