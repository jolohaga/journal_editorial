class CorrespondencesController < ApplicationController
  respond_to :html, :xml
  load_and_authorize_resource
  before_filter :remember_last_page_visited, :only => [:index, :hidden_correspondences]
  
  def index
    respond_with @correspondences = Correspondence.unhidden.order('created_at DESC').paginate(:page => params[:page], :per_page => 8)
  end

  def show
    @correspondence = Correspondence.includes(:attachments).find(params[:id])
    @attachments = @correspondence.attachments
  end

  def new
    @correspondence = Correspondence.new
  end

  def edit
    
  end

  def create
    @correspondence = Correspondence.new(params[:correspondence])
    if @correspondence.save
      flash[:notice] = "Successfully created correspondence."
    end
    respond_with @correspondence
  end

  def update
  end

  def destroy
  end
  
  def hide
    correspondence = Correspondence.find(params[:id])
    previously_hidden = correspondence.hidden
    correspondence.toggle!(:hidden)
    if previously_hidden
      redirect_to hidden_correspondences_path(:page => session[:last_hidden_correspondences_page])
    else
      redirect_to correspondences_path(:page => session[:last_unhidden_correspondences_page])
    end
  end
  
  def hidden_correspondences
    @correspondences = Correspondence.hidden.order('created_at DESC').paginate(:page => params[:page], :per_page => 8)
    render 'index'
  end
  
  private
  def remember_last_page_visited
    case params[:action]
    when 'index'
      session[:last_unhidden_correspondences_page] = params[:page]
    when 'hidden_correspondences'
      session[:last_hidden_correspondences_page] = params[:page]
    end
  end
end