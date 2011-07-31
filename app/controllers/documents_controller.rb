class DocumentsController < ApplicationController
  respond_to :html, :xml
  load_and_authorize_resource
  
  def index
    @folder = Folder.includes(:documents).find(params[:folder_id])
    respond_with @documents = @folder.documents
  end
  
  def show
    @document = Document.includes(:folder).find(params[:id])
    send_file(@document.working_file.path,
              :filename => @document.working_file.original_filename,
              :type => @document.working_file.content_type,
              :disposition => 'inline')
              
  end
  
  def new
    @folder = Folder.includes(:documents).find(params[:folder_id])
    @document = Document.new
    respond_with @folder
  end
  
  def create
    @folder = Folder.includes(:documents).find(params[:folder_id])
    @document = Document.new(params[:document])
    if @document.save
      @folder.documents << @document
      flash[:notice] = 'Document was successfully created.'
    end
    respond_with @document
  end
  
  def edit
    respond_with @document = Document.find(params[:id])
  end
  
  def update
    @document = Document.find(params[:id])
    if @document.update_attributes(params[:document])
      flash[:notice] = 'Document was successfully updated.'
    end
    respond_with @document
  end
  
  def destroy
    @document = Document.find(params[:id])
    @folder = @document.folder
    @document.destroy
    flash[:notice] = 'Document successfully destroyed!'
    respond_with @folder
  end
end