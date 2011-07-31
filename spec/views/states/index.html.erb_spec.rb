require 'spec_helper'

describe "states/index.html.erb" do
  before(:each) do
    assign(:states, [
      stub_model(State),
      stub_model(State)
    ])
  end

  it "renders a list of states" do
    render
  end
end
