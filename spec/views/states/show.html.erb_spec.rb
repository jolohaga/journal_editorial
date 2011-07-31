require 'spec_helper'

describe "states/show.html.erb" do
  before(:each) do
    @state = assign(:state, stub_model(State))
  end

  it "renders attributes in <p>" do
    render
  end
end
