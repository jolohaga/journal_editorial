require 'spec_helper'

describe "states/new.html.erb" do
  before(:each) do
    assign(:state, stub_model(State,
      :new_record? => true
    ))
  end

  it "renders new state form" do
    render

    rendered.should have_selector("form", :action => states_path, :method => "post") do |form|
    end
  end
end
