require 'spec_helper'

describe FormLettersController do

  def mock_form_letter(stubs={})
    @mock_form_letter ||= mock_model(FormLetter, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all form_letters as @form_letters" do
      FormLetter.stub(:all) { [mock_form_letter] }
      get :index
      assigns(:form_letters).should eq([mock_form_letter])
    end
  end

  describe "GET show" do
    it "assigns the requested form_letter as @form_letter" do
      FormLetter.stub(:find).with("37") { mock_form_letter }
      get :show, :id => "37"
      assigns(:form_letter).should be(mock_form_letter)
    end
  end

  describe "GET new" do
    it "assigns a new form_letter as @form_letter" do
      FormLetter.stub(:new) { mock_form_letter }
      get :new
      assigns(:form_letter).should be(mock_form_letter)
    end
  end

  describe "GET edit" do
    it "assigns the requested form_letter as @form_letter" do
      FormLetter.stub(:find).with("37") { mock_form_letter }
      get :edit, :id => "37"
      assigns(:form_letter).should be(mock_form_letter)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created form_letter as @form_letter" do
        FormLetter.stub(:new).with({'these' => 'params'}) { mock_form_letter(:save => true) }
        post :create, :form_letter => {'these' => 'params'}
        assigns(:form_letter).should be(mock_form_letter)
      end

      it "redirects to the created form_letter" do
        FormLetter.stub(:new) { mock_form_letter(:save => true) }
        post :create, :form_letter => {}
        response.should redirect_to(form_letter_url(mock_form_letter))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved form_letter as @form_letter" do
        FormLetter.stub(:new).with({'these' => 'params'}) { mock_form_letter(:save => false) }
        post :create, :form_letter => {'these' => 'params'}
        assigns(:form_letter).should be(mock_form_letter)
      end

      it "re-renders the 'new' template" do
        FormLetter.stub(:new) { mock_form_letter(:save => false) }
        post :create, :form_letter => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested form_letter" do
        FormLetter.should_receive(:find).with("37") { mock_form_letter }
        mock_form_letter.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :form_letter => {'these' => 'params'}
      end

      it "assigns the requested form_letter as @form_letter" do
        FormLetter.stub(:find) { mock_form_letter(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:form_letter).should be(mock_form_letter)
      end

      it "redirects to the form_letter" do
        FormLetter.stub(:find) { mock_form_letter(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(form_letter_url(mock_form_letter))
      end
    end

    describe "with invalid params" do
      it "assigns the form_letter as @form_letter" do
        FormLetter.stub(:find) { mock_form_letter(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:form_letter).should be(mock_form_letter)
      end

      it "re-renders the 'edit' template" do
        FormLetter.stub(:find) { mock_form_letter(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested form_letter" do
      FormLetter.should_receive(:find).with("37") { mock_form_letter }
      mock_form_letter.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the form_letters list" do
      FormLetter.stub(:find) { mock_form_letter }
      delete :destroy, :id => "1"
      response.should redirect_to(form_letters_url)
    end
  end

end
