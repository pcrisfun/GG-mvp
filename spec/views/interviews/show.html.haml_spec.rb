require 'spec_helper'

describe "interviews/show" do
  before(:each) do
    @interview = assign(:interview, stub_model(Interview,
      :app_signup => 1,
      :user_id => 2,
      :interview_time => "Interview Time",
      :interview_location => "Interview Location"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/Interview Time/)
    rendered.should match(/Interview Location/)
  end
end
