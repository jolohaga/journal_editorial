require "spec_helper"

describe SpecializationsController do
  describe "routing" do

        it "recognizes and generates #index" do
      { :get => "/specializations" }.should route_to(:controller => "specializations", :action => "index")
    end

        it "recognizes and generates #new" do
      { :get => "/specializations/new" }.should route_to(:controller => "specializations", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/specializations/1" }.should route_to(:controller => "specializations", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/specializations/1/edit" }.should route_to(:controller => "specializations", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/specializations" }.should route_to(:controller => "specializations", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/specializations/1" }.should route_to(:controller => "specializations", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/specializations/1" }.should route_to(:controller => "specializations", :action => "destroy", :id => "1") 
    end

  end
end
