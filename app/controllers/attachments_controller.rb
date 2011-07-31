class AttachmentsController < ApplicationController
  def download
    @attachment = Attachment.find(params[:id])
    send_file(@attachment.submitted_file.path,
              :filename => @attachment.submitted_file.original_filename,
              :type => @attachment.submitted_file.content_type,
              :disposition => 'inline')
  end
end