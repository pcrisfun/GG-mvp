require 'spec_helper'

describe "interviews/new" do
  before(:each) do
    assign(:interview, stub_model(Interview,
      :app_signup => 1,
      :user_id => 1,
      :interview_time => "MyString",
      :interview_location => "MyString"
    ).as_new_record)
  end

  it "renders new interview form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => interviews_path, :method => "post" do
      assert_select "input#interview_app_signup", :name => "interview[app_signup]"
      assert_select "input#interview_user_id", :name => "interview[user_id]"
      assert_select "input#interview_interview_time", :name => "interview[interview_time]"
      assert_select "input#interview_interview_location", :name => "interview[interview_location]"
    end
  end
end
