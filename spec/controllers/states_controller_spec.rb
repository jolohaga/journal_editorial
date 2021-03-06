require 'spec_helper'

describe StatesController do

  def mock_state(stubs={})
    @mock_state ||= mock_model(State, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all states as @states" do
      State.stub(:all) { [mock_state] }
      get :index
      assigns(:states).should eq([mock_state])
    end
  end

  describe "GET show" do
    it "assigns the requested state as @state" do
      State.stub(:find).with("37") { mock_state }
      get :show, :id => "37"
      assigns(:state).should be(mock_state)
    end
  end

  describe "GET new" do
    it "assigns a new state as @state" do
      State.stub(:new) { mock_state }
      get :new
      assigns(:state).should be(mock_state)
    end
  end

  describe "GET edit" do
    it "assigns the requested state as @state" do
      State.stub(:find).with("37") { mock_state }
      get :edit, :id => "37"
      assigns(:state).should be(mock_state)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created state as @state" do
        State.stub(:new).with({'these' => 'params'}) { mock_state(:save => true) }
        post :create, :state => {'these' => 'params'}
        assigns(:state).should be(mock_state)
      end

      it "redirects to the created state" do
        State.stub(:new) { mock_state(:save => true) }
        post :create, :state => {}
        response.should redirect_to(state_url(mock_state))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved state as @state" do
        State.stub(:new).with({'these' => 'params'}) { mock_state(:save => false) }
        post :create, :state => {'these' => 'params'}
        assigns(:state).should be(mock_state)
      end

      it "re-renders the 'new' template" do
        State.stub(:new) { mock_state(:save => false) }
        post :create, :state => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested state" do
        State.should_receive(:find).with("37") { mock_state }
        mock_state.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :state => {'these' => 'params'}
      end

      it "assigns the requested state as @state" do
        State.stub(:find) { mock_state(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:state).should be(mock_state)
      end

      it "redirects to the state" do
        State.stub(:find) { mock_state(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(state_url(mock_state))
      end
    end

    describe "with invalid params" do
      it "assigns the state as @state" do
        State.stub(:find) { mock_state(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:state).should be(mock_state)
      end

      it "re-renders the 'edit' template" do
        State.stub(:find) { mock_state(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested state" do
      State.should_receive(:find).with("37") { mock_state }
      mock_state.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the states list" do
      State.stub(:find) { mock_state }
      delete :destroy, :id => "1"
      response.should redirect_to(states_url)
    end
  end

end
