require 'spec_helper'

describe "submissions/index.html.erb" do
  before(:each) do
    assign(:submissions, [
      stub_model(Submission,
        :track_id => 1
      ),
      stub_model(Submission,
        :track_id => 1
      )
    ])
  end

  it "renders a list of submissions" do
    render
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
  end
end
