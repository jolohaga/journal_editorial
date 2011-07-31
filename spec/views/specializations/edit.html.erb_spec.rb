require 'spec_helper'

describe "specializations/edit.html.erb" do
  before(:each) do
    @specialization = assign(:specialization, stub_model(Specialization,
      :new_record? => false,
      :name => "MyString"
    ))
  end

  it "renders the edit specialization form" do
    render

    rendered.should have_selector("form", :action => specialization_path(@specialization), :method => "post") do |form|
      form.should have_selector("input#specialization_name", :name => "specialization[name]")
    end
  end
end
