class UsersController < ApplicationController
  respond_to :html, :xml
  load_and_authorize_resource
  
  def index
    session[:last_users_page] = params[:page]
    respond_with @users = User.includes(:roles).order('LOWER(users.last_name), LOWER(users.first_name)').paginate(:page => params[:page], :per_page => 8)
  end
  
  def show
    @user = User.includes(:roles).find(params[:id])
    @roles = @user.roles
    @role_selections = Role.select(['name','id']).map {|r| [r.name,r.id]}.sort
    respond_with @user
  end
  
  def new  
    respond_with @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Successfully created user."
    end
    respond_with(@user)
  end
  
  def edit
    respond_with @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank? # Ignore password if blank.
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
    end
    respond_with(@user)
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "Successfully destroyed user."
    respond_with(@user)
  end
  
  def assign_role
    @user = User.includes(:roles).find(params[:id])
    @role = Role.find(params[:role_id])
    @user.roles << @role unless @user.roles.find_by_id(@role)
    respond_with @user
  end
  
  def unassign_role
    @user = User.find(params[:id])
    @role = Role.find(params[:role_id])
    @user.roles.delete(@role)
    redirect_to @user
  end
end