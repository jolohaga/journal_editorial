require 'spec_helper'

describe "submissions/show.html.erb" do
  before(:each) do
    @submission = assign(:submission, stub_model(Submission,
      :track_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain(1.to_s)
  end
end
