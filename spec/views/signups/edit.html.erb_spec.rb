require 'spec_helper'

describe "signups/edit" do
  before(:each) do
    @signup = assign(:signup, stub_model(Signup,
      :happywhen => "MyText",
      :collaborate => "MyText",
      :interest => "MyText"
    ))
  end

  it "renders the edit signup form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => signups_path(@signup), :method => "post" do
      assert_select "textarea#signup_happywhen", :name => "signup[happywhen]"
      assert_select "textarea#signup_collaborate", :name => "signup[collaborate]"
      assert_select "textarea#signup_interest", :name => "signup[interest]"
    end
  end
end
