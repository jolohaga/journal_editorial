require 'spec_helper'

describe "form_letters/index.html.erb" do
  before(:each) do
    assign(:form_letters, [
      stub_model(FormLetter,
        :name => "Name",
        :body => "MyText"
      ),
      stub_model(FormLetter,
        :name => "Name",
        :body => "MyText"
      )
    ])
  end

  it "renders a list of form_letters" do
    render
    rendered.should have_selector("tr>td", :content => "Name".to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => "MyText".to_s, :count => 2)
  end
end
