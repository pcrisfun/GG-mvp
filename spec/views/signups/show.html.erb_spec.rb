require 'spec_helper'

describe "signups/show" do
  before(:each) do
    @signup = assign(:signup, stub_model(Signup,
      :happywhen => "MyText",
      :collaborate => "MyText",
      :interest => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
    rendered.should match(/MyText/)
  end
end
