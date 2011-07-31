require 'spec_helper'

describe SpecializationsController do

  def mock_specialization(stubs={})
    @mock_specialization ||= mock_model(Specialization, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all specializations as @specializations" do
      Specialization.stub(:all) { [mock_specialization] }
      get :index
      assigns(:specializations).should eq([mock_specialization])
    end
  end

  describe "GET show" do
    it "assigns the requested specialization as @specialization" do
      Specialization.stub(:find).with("37") { mock_specialization }
      get :show, :id => "37"
      assigns(:specialization).should be(mock_specialization)
    end
  end

  describe "GET new" do
    it "assigns a new specialization as @specialization" do
      Specialization.stub(:new) { mock_specialization }
      get :new
      assigns(:specialization).should be(mock_specialization)
    end
  end

  describe "GET edit" do
    it "assigns the requested specialization as @specialization" do
      Specialization.stub(:find).with("37") { mock_specialization }
      get :edit, :id => "37"
      assigns(:specialization).should be(mock_specialization)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created specialization as @specialization" do
        Specialization.stub(:new).with({'these' => 'params'}) { mock_specialization(:save => true) }
        post :create, :specialization => {'these' => 'params'}
        assigns(:specialization).should be(mock_specialization)
      end

      it "redirects to the created specialization" do
        Specialization.stub(:new) { mock_specialization(:save => true) }
        post :create, :specialization => {}
        response.should redirect_to(specialization_url(mock_specialization))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved specialization as @specialization" do
        Specialization.stub(:new).with({'these' => 'params'}) { mock_specialization(:save => false) }
        post :create, :specialization => {'these' => 'params'}
        assigns(:specialization).should be(mock_specialization)
      end

      it "re-renders the 'new' template" do
        Specialization.stub(:new) { mock_specialization(:save => false) }
        post :create, :specialization => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested specialization" do
        Specialization.should_receive(:find).with("37") { mock_specialization }
        mock_specialization.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :specialization => {'these' => 'params'}
      end

      it "assigns the requested specialization as @specialization" do
        Specialization.stub(:find) { mock_specialization(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:specialization).should be(mock_specialization)
      end

      it "redirects to the specialization" do
        Specialization.stub(:find) { mock_specialization(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(specialization_url(mock_specialization))
      end
    end

    describe "with invalid params" do
      it "assigns the specialization as @specialization" do
        Specialization.stub(:find) { mock_specialization(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:specialization).should be(mock_specialization)
      end

      it "re-renders the 'edit' template" do
        Specialization.stub(:find) { mock_specialization(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested specialization" do
      Specialization.should_receive(:find).with("37") { mock_specialization }
      mock_specialization.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the specializations list" do
      Specialization.stub(:find) { mock_specialization }
      delete :destroy, :id => "1"
      response.should redirect_to(specializations_url)
    end
  end

end
