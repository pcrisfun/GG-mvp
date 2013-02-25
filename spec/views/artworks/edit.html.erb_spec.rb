require 'spec_helper'

describe "artworks/edit" do
  before(:each) do
    @artwork = assign(:artwork, stub_model(Artwork,
      :title => "MyString",
      :year => 1,
      :material => "MyString",
      :category => "MyString"
    ))
  end

  it "renders the edit artwork form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => artworks_path(@artwork), :method => "post" do
      assert_select "input#artwork_title", :name => "artwork[title]"
      assert_select "input#artwork_year", :name => "artwork[year]"
      assert_select "input#artwork_material", :name => "artwork[material]"
      assert_select "input#artwork_category", :name => "artwork[category]"
    end
  end
end
