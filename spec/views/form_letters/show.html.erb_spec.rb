require 'spec_helper'

describe "form_letters/show.html.erb" do
  before(:each) do
    @form_letter = assign(:form_letter, stub_model(FormLetter,
      :name => "Name",
      :body => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain("Name".to_s)
    rendered.should contain("MyText".to_s)
  end
end
