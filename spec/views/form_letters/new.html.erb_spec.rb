require 'spec_helper'

describe "form_letters/new.html.erb" do
  before(:each) do
    assign(:form_letter, stub_model(FormLetter,
      :new_record? => true,
      :name => "MyString",
      :body => "MyText"
    ))
  end

  it "renders new form_letter form" do
    render

    rendered.should have_selector("form", :action => form_letters_path, :method => "post") do |form|
      form.should have_selector("input#form_letter_name", :name => "form_letter[name]")
      form.should have_selector("textarea#form_letter_body", :name => "form_letter[body]")
    end
  end
end
