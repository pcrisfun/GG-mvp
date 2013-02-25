require 'spec_helper'

describe "artworks/show" do
  before(:each) do
    @artwork = assign(:artwork, stub_model(Artwork,
      :title => "Title",
      :year => 1,
      :material => "Material",
      :category => "Category"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/1/)
    rendered.should match(/Material/)
    rendered.should match(/Category/)
  end
end
