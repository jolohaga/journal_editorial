require 'spec_helper'

describe "submissions/new.html.erb" do
  before(:each) do
    assign(:submission, stub_model(Submission,
      :new_record? => true,
      :track_id => 1
    ))
  end

  it "renders new submission form" do
    render

    rendered.should have_selector("form", :action => submissions_path, :method => "post") do |form|
      form.should have_selector("input#submission_track_id", :name => "submission[track_id]")
    end
  end
end
