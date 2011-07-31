require 'spec_helper'

describe "submissions/edit.html.erb" do
  before(:each) do
    @submission = assign(:submission, stub_model(Submission,
      :new_record? => false,
      :track_id => 1
    ))
  end

  it "renders the edit submission form" do
    render

    rendered.should have_selector("form", :action => submission_path(@submission), :method => "post") do |form|
      form.should have_selector("input#submission_track_id", :name => "submission[track_id]")
    end
  end
end
