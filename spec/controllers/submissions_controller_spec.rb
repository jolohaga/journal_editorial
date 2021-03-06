require 'spec_helper'

describe SubmissionsController do

  def mock_submission(stubs={})
    @mock_submission ||= mock_model(Submission, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all submissions as @submissions" do
      Submission.stub(:all) { [mock_submission] }
      get :index
      assigns(:submissions).should eq([mock_submission])
    end
  end

  describe "GET show" do
    it "assigns the requested submission as @submission" do
      Submission.stub(:find).with("37") { mock_submission }
      get :show, :id => "37"
      assigns(:submission).should be(mock_submission)
    end
  end

  describe "GET new" do
    it "assigns a new submission as @submission" do
      Submission.stub(:new) { mock_submission }
      get :new
      assigns(:submission).should be(mock_submission)
    end
  end

  describe "GET edit" do
    it "assigns the requested submission as @submission" do
      Submission.stub(:find).with("37") { mock_submission }
      get :edit, :id => "37"
      assigns(:submission).should be(mock_submission)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created submission as @submission" do
        Submission.stub(:new).with({'these' => 'params'}) { mock_submission(:save => true) }
        post :create, :submission => {'these' => 'params'}
        assigns(:submission).should be(mock_submission)
      end

      it "redirects to the created submission" do
        Submission.stub(:new) { mock_submission(:save => true) }
        post :create, :submission => {}
        response.should redirect_to(submission_url(mock_submission))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved submission as @submission" do
        Submission.stub(:new).with({'these' => 'params'}) { mock_submission(:save => false) }
        post :create, :submission => {'these' => 'params'}
        assigns(:submission).should be(mock_submission)
      end

      it "re-renders the 'new' template" do
        Submission.stub(:new) { mock_submission(:save => false) }
        post :create, :submission => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested submission" do
        Submission.should_receive(:find).with("37") { mock_submission }
        mock_submission.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :submission => {'these' => 'params'}
      end

      it "assigns the requested submission as @submission" do
        Submission.stub(:find) { mock_submission(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:submission).should be(mock_submission)
      end

      it "redirects to the submission" do
        Submission.stub(:find) { mock_submission(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(submission_url(mock_submission))
      end
    end

    describe "with invalid params" do
      it "assigns the submission as @submission" do
        Submission.stub(:find) { mock_submission(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:submission).should be(mock_submission)
      end

      it "re-renders the 'edit' template" do
        Submission.stub(:find) { mock_submission(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested submission" do
      Submission.should_receive(:find).with("37") { mock_submission }
      mock_submission.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the submissions list" do
      Submission.stub(:find) { mock_submission }
      delete :destroy, :id => "1"
      response.should redirect_to(submissions_url)
    end
  end

end
