class TagsController < ApplicationController
  respond_to :html, :xml
  load_and_authorize_resource
  
  def create
    @form_letter = FormLetter.find(params[:form_letter_id])
    @form_letter.tags << Tag.new(:name => params[:name])
    respond_with @form_letter
  end

  def destroy
    tag = Tag.find(params[:id])
    @form_letter = tag.taggable
    tag.destroy
    respond_with @form_letter
  end
end
