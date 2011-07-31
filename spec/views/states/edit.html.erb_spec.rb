require 'spec_helper'

describe "states/edit.html.erb" do
  before(:each) do
    @state = assign(:state, stub_model(State,
      :new_record? => false
    ))
  end

  it "renders the edit state form" do
    render

    rendered.should have_selector("form", :action => state_path(@state), :method => "post") do |form|
    end
  end
end
