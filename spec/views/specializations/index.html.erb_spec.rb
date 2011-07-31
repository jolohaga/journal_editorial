require 'spec_helper'

describe "specializations/index.html.erb" do
  before(:each) do
    assign(:specializations, [
      stub_model(Specialization,
        :name => "Name"
      ),
      stub_model(Specialization,
        :name => "Name"
      )
    ])
  end

  it "renders a list of specializations" do
    render
    rendered.should have_selector("tr>td", :content => "Name".to_s, :count => 2)
  end
end
