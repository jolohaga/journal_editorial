require 'zip/zip'

class FoldersController < ApplicationController
  respond_to :html, :xml
  load_and_authorize_resource
  
  def index
    @submission = Submission.includes(:folders).find(params[:submission_id])
    respond_with @folders = @submission.folders
  end
  
  def show
    @folder = Folder.includes(:submission,:documents,:comments).find(params[:id])
    @submission = @folder.submission
    @documents = @folder.documents
    @comments = @folder.comments
    respond_with @folder
  end
  
  def new
    @submission = Submission.find(params[:submission_id])
    @folder = Folder.new
    respond_with @folder
  end
  
  def create
    @submission = Submission.includes(:folders).find(params[:submission_id])
    @folder = Folder.new(params[:folder])
    @folder.assignment_number = @submission.next_folder_assignment
    @submission.folders << @folder
    @folder.comments << Comment.new(params[:comments]) unless params[:comments][:comment].blank?
    process_multiple_files
    flash[:notice] = 'Folder successfully created!'
    if session[:return_to_state_management]
      session[:return_to_state_management] = false
      respond_with @submission, :location => submission_states_path(@submission)
    else
      respond_with @submission
    end
  end
  
  def edit
    @folder = Folder.includes(:submission, :documents).find(params[:id])
    @submission = @folder.submission
    @documents = @folder.documents
    respond_with @folder
  end
  
  def update
    @folder = Folder.find(params[:id])
    if @folder.update_attributes(params[:folder])
      flash[:notice] = 'Folder successfully updated!'
    end
    respond_with @folder
  end
  
  def destroy
    @folder = Folder.includes(:submission).find(params[:id])
    @submission = @folder.submission
    @folder.destroy
    flash[:notice] = 'Folder successfully destroyed!'
    respond_with @submission
  end
  
  def upload
    @folder = Folder.includes(:submission).find(params[:id])
    @submission = @folder.submission
    process_multiple_files
    respond_with @folder
  end
  
  def download
    @folder = Folder.includes(:documents).find(params[:id])
    file_name = "#{@folder.cached_slug} #{@folder.activity_attempt_display}.zip".gsub(/[: ]/,'_').downcase
    tmp_f = Tempfile.new("#{rand(36**8).to_s(36)}-#{Time.now.strftime("%Y%m%d%H%M%S")}")
    Zip::ZipOutputStream.open(tmp_f.path) do |zip_f|
      @folder.documents.each do |doc|
        zip_f.put_next_entry(doc.working_file.original_filename)
        zip_f.write IO.read(doc.working_file.path)
      end
    end
    send_file(tmp_f.path,
              :filename => file_name,
              :type => 'application/zip',
              :disposition => 'inline')
  end
  
  # Process multiple files passed in through params[:upload_data].
  # Expecting @folder is instantiated
  def process_multiple_files
    params[:upload_data].each do |file|
      document = Document.new(:assignment_number => @folder.next_document_assignment)
      document.working_file = file
      @folder.documents << document
    end
  end
end