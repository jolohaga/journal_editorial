class FormLettersController < ApplicationController
  respond_to :html, :xml
  load_and_authorize_resource

  def index
    paginate_params = {:page => params[:page], :per_page => 5}
    respond_with @form_letters = FormLetter.order('notifiable_type ASC, name ASC').paginate(paginate_params)
  end

  def show
    @form_letter = FormLetter.includes(:tags).find(params[:id])
    @tags = @form_letter.tags
    @tags_selection = (Submission.state_machine.states.keys.sort.map{|key| key.to_s} - @tags.map{|tag| tag.name})
    respond_with @form_letter
  end

  def new
    @form_letter = FormLetter.new
    populate_form_fields
    respond_with @form_letter
  end

  def edit
    @form_letter = FormLetter.find(params[:id])
    populate_form_fields
    respond_with @form_letter
  end

  def create
    @form_letter = FormLetter.new(params[:form_letter])
    if @form_letter.save
      flash[:notice] = "Successfully created form letter."
    end
    respond_with @form_letter
  end
  
  def update
    @form_letter = FormLetter.find(params[:id])
    if @form_letter.update_attributes(params[:form_letter])
      flash[:notice] = "Successfully updated form letter."
    end
    respond_with @form_letter
  end

  def destroy
    @form_letter = FormLetter.find(params[:id])
    @form_letter.destroy
    flash[:notice] = "Successfully destroyed form letter."
    respond_wth @form_letter
  end
  
  def populate_form_fields
    @from = @form_letter.default_from || Journal::FormLetters::FROM.join(', ')
    @reply_to = @form_letter.default_reply_to || Journal::FormLetters::REPLY_TO.join(', ')
    @cc = @form_letter.default_cc_recipients || Journal::FormLetters::REPLY_TO.join(', ')
    @signature = @form_letter.signature || Journal::FormLetters::SIGNATURE
  end
end