require 'spec_helper'

describe "signups/new" do
  before(:each) do
    assign(:signup, stub_model(Signup,
      :happywhen => "MyText",
      :collaborate => "MyText",
      :interest => "MyText"
    ).as_new_record)
  end

  it "renders new signup form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => signups_path, :method => "post" do
      assert_select "textarea#signup_happywhen", :name => "signup[happywhen]"
      assert_select "textarea#signup_collaborate", :name => "signup[collaborate]"
      assert_select "textarea#signup_interest", :name => "signup[interest]"
    end
  end
end
