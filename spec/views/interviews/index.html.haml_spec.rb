require 'spec_helper'

describe "interviews/index" do
  before(:each) do
    assign(:interviews, [
      stub_model(Interview,
        :app_signup => 1,
        :user_id => 2,
        :interview_time => "Interview Time",
        :interview_location => "Interview Location"
      ),
      stub_model(Interview,
        :app_signup => 1,
        :user_id => 2,
        :interview_time => "Interview Time",
        :interview_location => "Interview Location"
      )
    ])
  end

  it "renders a list of interviews" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Interview Time".to_s, :count => 2
    assert_select "tr>td", :text => "Interview Location".to_s, :count => 2
  end
end
