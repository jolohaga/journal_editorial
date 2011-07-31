class SpecializationsController < ApplicationController
  respond_to :html, :xml
  load_and_authorize_resource
  
  def index
    @specializations = Specialization.order('category, name').paginate(:page => params[:page], :per_page => 8)
  end

  # GET /specializations/1
  # GET /specializations/1.xml
  def show
    @specialization = Specialization.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @specialization }
    end
  end

  # GET /specializations/new
  # GET /specializations/new.xml
  def new
    @specialization = Specialization.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @specialization }
    end
  end

  # GET /specializations/1/edit
  def edit
    @specialization = Specialization.find(params[:id])
  end

  # POST /specializations
  # POST /specializations.xml
  def create
    @specialization = Specialization.new(params[:specialization])

    respond_to do |format|
      if @specialization.save
        format.html { redirect_to(@specialization, :notice => 'Specialization was successfully created.') }
        format.xml  { render :xml => @specialization, :status => :created, :location => @specialization }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @specialization.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /specializations/1
  # PUT /specializations/1.xml
  def update
    @specialization = Specialization.find(params[:id])

    respond_to do |format|
      if @specialization.update_attributes(params[:specialization])
        format.html { redirect_to(@specialization, :notice => 'Specialization was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @specialization.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /specializations/1
  # DELETE /specializations/1.xml
  def destroy
    @specialization = Specialization.find(params[:id])
    @specialization.destroy

    respond_to do |format|
      format.html { redirect_to(specializations_url) }
      format.xml  { head :ok }
    end
  end
end
