require 'spec_helper'

describe "interviews/edit" do
  before(:each) do
    @interview = assign(:interview, stub_model(Interview,
      :app_signup => 1,
      :user_id => 1,
      :interview_time => "MyString",
      :interview_location => "MyString"
    ))
  end

  it "renders the edit interview form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => interviews_path(@interview), :method => "post" do
      assert_select "input#interview_app_signup", :name => "interview[app_signup]"
      assert_select "input#interview_user_id", :name => "interview[user_id]"
      assert_select "input#interview_interview_time", :name => "interview[interview_time]"
      assert_select "input#interview_interview_location", :name => "interview[interview_location]"
    end
  end
end
