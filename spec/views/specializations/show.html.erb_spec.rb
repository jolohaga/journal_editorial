require 'spec_helper'

describe "specializations/show.html.erb" do
  before(:each) do
    @specialization = assign(:specialization, stub_model(Specialization,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain("Name".to_s)
  end
end
