require "spec_helper"

describe FormLettersController do
  describe "routing" do

        it "recognizes and generates #index" do
      { :get => "/form_letters" }.should route_to(:controller => "form_letters", :action => "index")
    end

        it "recognizes and generates #new" do
      { :get => "/form_letters/new" }.should route_to(:controller => "form_letters", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/form_letters/1" }.should route_to(:controller => "form_letters", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/form_letters/1/edit" }.should route_to(:controller => "form_letters", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/form_letters" }.should route_to(:controller => "form_letters", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/form_letters/1" }.should route_to(:controller => "form_letters", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/form_letters/1" }.should route_to(:controller => "form_letters", :action => "destroy", :id => "1") 
    end

  end
end
