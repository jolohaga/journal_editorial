require 'spec_helper'

describe "specializations/new.html.erb" do
  before(:each) do
    assign(:specialization, stub_model(Specialization,
      :new_record? => true,
      :name => "MyString"
    ))
  end

  it "renders new specialization form" do
    render

    rendered.should have_selector("form", :action => specializations_path, :method => "post") do |form|
      form.should have_selector("input#specialization_name", :name => "specialization[name]")
    end
  end
end
