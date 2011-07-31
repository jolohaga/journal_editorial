class RolesController < ApplicationController
  respond_to :html, :xml
  load_and_authorize_resource
  
  def index
    respond_with @roles = Role.all
  end
  
  def show
    respond_with @role = Role.find(params[:id])
  end
  
  def new
    respond_with @role = Role.new
  end
  
  def create
    @role = Role.new(params[:role])
    if @role.save
      flash[:notice] = "Successfully created role."
    end
    respond_with(@role)
  end
  
  def edit
    respond_with @role = Role.find(params[:id])
  end
  
  def update
    @role = Role.find(params[:id])
    if @role.update_attributes(params[:role])
      flash[:notice] = "Successfully updated role."
    end
    respond_with(@role)
  end
  
  def destroy
    @role = Role.find(params[:id])
    @role.destroy
    flash[:notice] = "Successfully destroyed role."
    respond_with(@role)
  end
end