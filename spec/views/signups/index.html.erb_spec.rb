require 'spec_helper'

describe "signups/index" do
  before(:each) do
    assign(:signups, [
      stub_model(Signup,
        :happywhen => "MyText",
        :collaborate => "MyText",
        :interest => "MyText"
      ),
      stub_model(Signup,
        :happywhen => "MyText",
        :collaborate => "MyText",
        :interest => "MyText"
      )
    ])
  end

  it "renders a list of signups" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
